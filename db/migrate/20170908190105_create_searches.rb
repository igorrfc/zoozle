class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :description
      t.integer :popularity

      t.timestamps
    end

    add_index :searches, :description
  end
end
