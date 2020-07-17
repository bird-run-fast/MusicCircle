class CreateConcerns < ActiveRecord::Migration[5.2]
  def change
    create_table :concerns do |t|
      t.integer :enduser_id
      t.integer :post_id
      t.timestamps
    end
  end
end
