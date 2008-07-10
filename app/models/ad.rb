class Ad
  def initialize(story = nil, product = nil, score = 0) 
    @story = story 
    @product = product 
    @score = score
  end
  
  attr_accessor :story, :product, :score
  
  # TODO: Do we need to escape XML content first?
  def to_xml
    x = Builder::XmlMarkup.new
    x.ad {
      x.story @story.nil? ? "" : @story.title
      x.product @product.nil? ? "" : @product.name
      x.score score
      x.ad_copy @product.nil? ? "" : @product.ad_copy
      x.product_link @product.nil? ? "" : "URL to FNB"
      x.product_link_text @product.nil? ? "" : "Link Text to FNB product URL"
    }
  end

  def to_s
    to_xml
  end

  def relevant?
    @score > 0
  end
end