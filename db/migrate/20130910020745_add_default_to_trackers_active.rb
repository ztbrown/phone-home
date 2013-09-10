class AddDefaultToTrackersActive < ActiveRecord::Migration
  def up
    change_column_default :trackers, :active, false
  end

  def down
    change_column_default :trackers, :active, nil
  end
end
