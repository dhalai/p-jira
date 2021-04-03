class AddAuditLog < ActiveRecord::Migration[6.1]
  def change
    create_table :auditlogs, id: :uuid do |t|
      t.string :public_id, null: false
      t.uuid :user_id, null: false
      t.uuid :task_id, default: nil
      t.bigint :credit
      t.bigint :debit

      t.timestamps
    end
  end
end
