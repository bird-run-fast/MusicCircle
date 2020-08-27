class CreateTwSentiments < ActiveRecord::Migration[5.2]
  def change
    create_table :tw_sentiments do |t|

      t.float :score
      t.integer :tw_count
      t.boolean :latest, default: true 
      t.timestamps
    end
  end
end
