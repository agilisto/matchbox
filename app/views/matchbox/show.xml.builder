cache(["matchbox", current_site.identifier]) do
  xml.instruct! :xml, :version=>"1.0" 
  xml.matchbox {
    xml.last_refreshed(Setting.last_refreshed_at)
    xml.ads {
      current_site.ads.each do |ad|
        xml << ad.to_xml
      end
    }
  }
end

