xml.instruct! :xml, :version=>"1.0" 
xml.matchbox {
  xml.ads {
    current_site.ads.each do |ad|
      xml << ad.to_xml
    end
  }
}