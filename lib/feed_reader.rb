require 'open-uri'
require 'feed-normalizer'
 
module FeedReader
  # Returns an array of stories (id, title, content etc), or nil if the url didn't work.
  def self.process(url)
    stories = []
    feed = FeedNormalizer::FeedNormalizer.parse open(url.strip)
    feed.nil? ? nil : stories.push(*feed.entries)
  end
end