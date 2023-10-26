class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :liking_user_id
      t.integer :liked_user_id

      t.timestamps
    end
  end
end
