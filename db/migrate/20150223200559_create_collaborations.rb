class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :user, index: true, null: false
      t.references :list, index: true, null: false

      t.timestamps
    end
    add_foreign_key :collaborations, :users, on_delete: :cascade
    add_foreign_key :collaborations, :lists, on_delete: :cascade
    add_index :collaborations, [:user_id, :list_id], unique: true
  end
end
