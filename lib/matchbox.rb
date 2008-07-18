class Matchbox
  # Fetches the stories for all sites
  def self.fetch_stories
    Site.find(:all).each do |site|
      site.fetch_stories
    end
    return Story.not_expired.count
  end
  
  # Calls the Ultrasphinx rake task and returns the stdout
  def self.index_stories
    ok = false
    output = []
    IO.popen("cd #{RAILS_ROOT} && rake ultrasphinx:index RAILS_ENV=#{ENV['RAILS_ENV']}") do |pipe|
      pipe.each("\r") do |line|
        output << line
        ok = true if line =~ /Index rotated ok/
      end
    end
    let_the_world_know if ok
    return output.join("\n")
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

private

  def self.let_the_world_know
    Setting.last_indexed_at!
    #expire_cache
  end
  
end