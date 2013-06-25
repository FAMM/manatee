class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.decimal :budget, precision: 20, scale: 2

      t.timestamps
    end
  end
end
