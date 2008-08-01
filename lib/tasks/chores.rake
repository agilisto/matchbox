namespace :chores do
  
  # Every three minutes
  task :three_minutes do
    chore("Three_minutes") do
      load 'config/environment.rb'
      Ultrasphinx.with_rake = true
      FileUtils.mkdir_p File.dirname(Ultrasphinx::DAEMON_SETTINGS["log"]) rescue nil
      raise Ultrasphinx::DaemonError, "Already running" if ultrasphinx_daemon_running?
      system "searchd --config '#{Ultrasphinx::CONF_PATH}'"
      sleep(4) # give daemon a chance to write the pid file
      if ultrasphinx_daemon_running?
        say "started successfully"
      else
        say "failed to start"
      end
    end
  end

  # 4 times / hour.
  task :quarterly => :environment do
    chore("Quaterly") do
      Rake::Task['matchbox:refresh'].invoke
    end
  end

  task :hourly => :environment do
    chore("Hourly") do
      # Your Code Here
    end
  end
  
  task :daily => :environment do
    chore("Daily") do
      # Your Code Here
    end
  end
  
  task :weekly => :environment do
    chore("Weekly") do
      # Your Code Here
    end
  end
  
  def chore(name)
    puts "#{name} Task Invoked: #{Time.now}"
    yield
    puts "#{name} Task Finished: #{Time.now}"
  end
end

# support methods

def ultrasphinx_daemon_pid
  open(open(Ultrasphinx::BASE_PATH).readlines.map do |line| 
    line[/^\s*pid_file\s*=\s*([^\s\#]*)/, 1]
  end.compact.first).readline.chomp rescue nil # XXX ridiculous
end

def ultrasphinx_daemon_running?
  if ultrasphinx_daemon_pid and `ps -p #{ultrasphinx_daemon_pid} | wc`.to_i > 1 
    true
  else
    # remove bogus lockfiles
    Dir[Ultrasphinx::INDEX_SETTINGS["path"] + "*spl"].each {|file| File.delete(file)}
    false
  end  
end

def say msg
  Ultrasphinx.say msg
end
