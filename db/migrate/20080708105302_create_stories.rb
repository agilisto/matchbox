class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.integer :site_id
      t.string :uri
      t.string :title
      t.string :content
      t.datetime :expired_at

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
