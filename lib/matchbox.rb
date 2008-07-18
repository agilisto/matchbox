class Matchbox
  # Fetches the stories for all sites
  def self.fetch_stories
    Site.find(:all).each do |site|
      site.fetch_stories
    end
    return Story.not_expired.count
  end
  
  def self.index
    Ultrasphinx.with_rake = false
    rotate = ultrasphinx_daemon_running?
    index_path = Ultrasphinx::INDEX_SETTINGS['path']
    mkdir_p index_path unless File.directory? index_path
    
    cmd = "indexer --config '#{Ultrasphinx::CONF_PATH}'"
    cmd << " #{ENV['OPTS']} " if ENV['OPTS']
    cmd << " --rotate" if true # rotate
    cmd << " #{Ultrasphinx::UNIFIED_INDEX_NAME}"
    
    say cmd
    system cmd
        
    if rotate
      sleep(4)
      failed = Dir[index_path + "/*.new.*"]
      if failed.any?
        say "warning; index failed to rotate! Deleting new indexes"
        failed.each {|f| File.delete f }
        return false
      else
        say "index rotated ok"
        let_the_world_know
        return true
      end
    else
      let_the_world_know
      return true
    end
  end
  
  def self.generate_ads
    FileUtils.makedirs(cache_directory)
    Site.find(:all).each do |site|
      File.open(cache_directory + "/#{site.identifier}.xml", "w") { |f| f.write(site.ads_xml_document) }
    end
    return Site.count
  end

  def self.expire_cache
    FileUtils.rm_r(Dir.glob(cache_directory + "/*")) rescue Errno::ENOENT
    RAILS_DEFAULT_LOGGER.info("Expired all matchboxes.")
  end
  
  def self.cache_directory
    cache_dir = ActionController::Base.page_cache_directory + "/matchbox"
  end

  def self.let_the_world_know
    Setting.last_indexed_at!
    #expire_cache
  end
  
private

  def self.ultrasphinx_daemon_pid
    open(open(Ultrasphinx::BASE_PATH).readlines.map do |line| 
      line[/^\s*pid_file\s*=\s*([^\s\#]*)/, 1]
    end.compact.first).readline.chomp rescue nil # XXX ridiculous
  end

  def self.ultrasphinx_daemon_running?
    if ultrasphinx_daemon_pid and `ps -p #{ultrasphinx_daemon_pid} | wc`.to_i > 1 
      true
    else
      # remove bogus lockfiles
      Dir[Ultrasphinx::INDEX_SETTINGS["path"] + "*spl"].each {|file| File.delete(file)}
      false
    end  
  end

  def self.say msg
    Ultrasphinx.say msg
  end

end