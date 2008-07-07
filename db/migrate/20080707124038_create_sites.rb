class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :identifier
      t.string :homepage_url
      t.string :feed_url

      t.timestamps
    end

    add_index :sites, :identifier, :unique => true
  end

  def self.down
    drop_table :sites
  end
end
