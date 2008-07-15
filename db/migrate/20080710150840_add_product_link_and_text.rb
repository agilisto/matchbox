class AddProductLinkAndText < ActiveRecord::Migration
  def self.up
    add_column :products, :link, :string
    add_column :products, :link_text, :string
  end

  def self.down
  end
end
