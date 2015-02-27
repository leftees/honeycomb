class AddTimestampsToShowcases < ActiveRecord::Migration
  def change
    add_column(:showcases, :updated_at, :datetime)
    add_column(:showcases, :created_at, :datetime)

    Showcase.update_all("updated_at = '#{Time.now.to_s(:db)}'")
    Showcase.update_all("created_at = '#{Time.now.to_s(:db)}'")
  end
end
