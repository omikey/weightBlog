class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :date
      t.text :content

      t.timestamps null: false
    end
  end
end
