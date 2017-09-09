class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :description
      t.integer :popularity, default: 0

      t.timestamps
    end

    add_index :searches, :description
  end
end
