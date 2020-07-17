class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :enduser_id
      t.string :title
      t.text :body
      t.boolean :is_valid
      t.timestamps
    end
  end
end
