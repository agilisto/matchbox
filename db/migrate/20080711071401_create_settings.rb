class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.datetime :last_indexed_at
      t.datetime :last_refreshed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
