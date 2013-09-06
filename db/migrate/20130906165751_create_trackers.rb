class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :name
      t.string :token
      t.boolean :active
      t.references :user, index: true

      t.timestamps
    end

    add_index :trackers, :token, unique: true
  end
end
