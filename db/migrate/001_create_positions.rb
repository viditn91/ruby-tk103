class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :lat
      t.float :lon
      t.string :device
      t.timestamps
    end
  end
end