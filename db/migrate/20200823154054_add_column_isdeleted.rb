class AddColumnIsdeleted < ActiveRecord::Migration[5.2]
  def change
    add_column :endusers, :is_deleted, :boolean, default: false, null: false
  end
end
