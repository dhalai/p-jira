class AddAuthIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :auth_identities, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :login, null: false
      t.string :token

      t.timestamps
    end
  end
end
