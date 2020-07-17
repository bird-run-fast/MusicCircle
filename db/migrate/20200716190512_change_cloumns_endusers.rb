class ChangeCloumnsEndusers < ActiveRecord::Migration[5.2]
  def change
    change_column :endusers, :area, :integer
    change_column :endusers, :age, :integer
  end
end
