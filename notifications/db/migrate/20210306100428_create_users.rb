class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :full_name
      t.string :public_id
      t.string :email
      t.string :phone_number
      t.string :slack_account

      t.timestamps
    end
  end
end
