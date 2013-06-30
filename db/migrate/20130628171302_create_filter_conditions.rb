class CreateFilterConditions < ActiveRecord::Migration
  def change
    create_table :filter_conditions do |t|
      t.string :connector
      t.string :column
      t.string :operator
      t.string :value
      t.integer :filter_id

      t.timestamps
    end
  end
end
