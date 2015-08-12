class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.integer :day
      t.decimal :size

      t.timestamps null: false
    end
  end
end
