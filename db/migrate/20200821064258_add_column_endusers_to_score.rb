class AddColumnEndusersToScore < ActiveRecord::Migration[5.2]
  def up
    add_column :endusers, :score, :float
  end
end
