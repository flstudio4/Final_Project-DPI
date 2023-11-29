class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }
      t.references :visited, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
