class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :full_name
      t.string :public_id
      t.string :email
      t.integer :role
      t.bigint :balance, default: 0

      t.timestamps
    end
  end
end
