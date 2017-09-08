class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :ip
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end
