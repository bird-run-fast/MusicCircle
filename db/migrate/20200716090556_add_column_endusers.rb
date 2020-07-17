class AddColumnEndusers < ActiveRecord::Migration[5.2]
  def change
    add_column :endusers, :name, :string
    add_column :endusers, :area, :string
    add_column :endusers, :age, :integer
    add_column :endusers, :introduction, :text
    add_column :endusers, :image_id, :string
  end
end
