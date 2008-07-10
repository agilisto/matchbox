class Product < ActiveRecord::Base
  validates_presence_of :name

  validates_format_of :link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
  :message => "doesn't look right (don't forget the protocol eg http://)",
                      :allow_nil => true,
                      :allow_blank => true

  # Return a bunch relevant stories with their scores for this product, scoped on the site
  # Phrases - like Google - need to be in quotes for an EXACT match
  # So we get a sorted array by score ... [[story_id1, score1], [story_id2, score2]]
  # This returns even those stories with 0 score. (not sure why Sphinx does this?)
  # Note: Very important to reindex before running this ... TODO: Put in some sort of check for this.
  def score_stories(site)
    scores = {}
    site.stories.current.each do |story|
      scores[story.id] = 0
    end
    keywords.split("\n").each do |keyword|
      # query needs to be enclose in double quotes if we have a phrase
      query = keyword.split.size > 1 ? "\"#{keyword}\"" : keyword
      search = Ultrasphinx::Search.new(   :class_name => "Story",
                                          :filters => { "site_id" => site.id },
                                          :weights => {"title" => 2.0},
                                          :query => query).run
      search.response[:matches].each do |match|
        scores[match[:doc]] += match[:weight]
      end
    end
    return scores.sort { |a, b| a[1] <=> b[1] }.reverse
  end
end
