require File.dirname(__FILE__) + '/../test_helper'

class AdTest < ActiveSupport::TestCase
  def test_xml
    site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
    product = Product.create!(:name => "Offshore", :keywords => "Nadal\nto\narrives", :ad_copy => "Invest offshore")
    story = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero's welcome", :site => site)
    ad = Ad.new(story, product, 7500)

    x = Builder::XmlMarkup.new
    x.ad {
      x.story "Nadal arrives home to hero's welcome"
      x.product "Offshore"
      x.score 7500
      x.ad_copy "Invest offshore"
      x.product_link "URL to FNB"
      x.product_link_text "Link Text to FNB product URL"
    }

    assert_equal x, ad.to_xml
  end
  
end
