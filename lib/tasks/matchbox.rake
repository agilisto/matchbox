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
      if Matchbox.index
        puts "Done"
      else
        puts "Failed"
      end
    end
  
    desc "Creates XML ads for all stories"
    task :generate_ads do
      puts "Creating XML matchbox ads ..."
      load 'config/environment.rb'
      sites = Matchbox.generate_ads
      puts "Generated xml for #{sites} sites."
    end
  
  end

  desc "Fetches and indexes the latest stories, and creates relevancy xml files"
  task :refresh => ["stories:fetch", "stories:index", "stories:generate_ads"] do
    puts "Matchbox has been refreshed."
    Setting.last_refreshed_at!
  end
end