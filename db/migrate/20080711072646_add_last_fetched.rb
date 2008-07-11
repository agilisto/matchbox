class AddLastFetched < ActiveRecord::Migration
  def self.up
    add_column :sites, :last_fetched_at, :datetime
  end

  def self.down
  end
end
