class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :user_id

      t.timestamps
    end
  end
end
