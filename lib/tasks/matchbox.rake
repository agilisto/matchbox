namespace :matchbox do
    namespace :stories do
  
    desc "Fetches the latest stories"
    task :fetch do
      puts "Fetching matchbox stories ..."
      load 'config/environment.rb'
      stories = Matchbox.fetch_stories
      puts "Fetched #{stories} stories."
    end
  
    desc "Indexes the latest stories"
    task :index do
      puts "Indexing matchbox stories ..."
      load 'config/environment.rb'
      output = Matchbox.index_stories
    end
  
  end

  desc "Fetches and indexes the latest stories, and creates relevancy xml files"
  task :refresh => ["stories:fetch", "stories:index"] do
    puts "Matchbox has been refreshed."
    Setting.last_refreshed_at!
  end
end