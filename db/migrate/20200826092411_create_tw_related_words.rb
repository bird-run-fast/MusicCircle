class CreateTwRelatedWords < ActiveRecord::Migration[5.2]
  def change
    create_table :tw_related_words do |t|
      t.string :name
      t.float :salience
      t.boolean :latest, default: true  
      t.timestamps
    end
  end
end
