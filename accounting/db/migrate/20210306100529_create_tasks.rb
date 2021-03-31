class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.string :public_id, null: false
      t.uuid :user_id, default: nil
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
