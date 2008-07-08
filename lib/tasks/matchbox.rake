namespace :matchbox do
    namespace :stories do
  
    desc "Fetches the latest stories"
    task :fetch do
      puts "Fetching matchbox stories ..."
      load 'config/environment.rb'
    end
  
    desc "Indexes the latest stories"
    task :index do
      puts "Indexing matchbox stories ..."
      load 'config/environment.rb'
      Matchbox.index_stories
    end
  
  end

  desc "Fetches and indexes the latest stories, and creates relevancy xml files"
  task :refresh => ["stories:fetch", "stories:index"] do
  end
end