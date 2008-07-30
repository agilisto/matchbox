namespace :chores do
  
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