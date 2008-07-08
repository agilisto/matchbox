require 'open-uri'
require 'feed-normalizer'
 
module FeedReader
  # Returns an array of stories (id, title, content etc), or nil if the url didn't work.
  def self.process(url)
    begin
      stories = []
      feed = FeedNormalizer::FeedNormalizer.parse open(url.strip)
      stories.push(*feed.entries)
    rescue
      return nil
    end
  end
end