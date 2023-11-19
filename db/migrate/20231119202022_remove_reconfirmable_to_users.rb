class RemoveReconfirmableToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :unconfirmed_email, :string
  end
end
