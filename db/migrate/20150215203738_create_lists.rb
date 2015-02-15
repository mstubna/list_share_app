class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :title
      t.text :body
      t.references :user, index: true, null: false

      t.timestamps
    end
    add_foreign_key :lists, :users, on_delete: :cascade
  end
end
