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
    output = []
    IO.popen("cd #{RAILS_ROOT} && rake ultrasphinx:index RAILS_ENV=#{ENV['RAILS_ENV']}") do |pipe|
      pipe.each("\r") do |line|
        output << line
      end
    end
    return output.join("\n")
  end
end