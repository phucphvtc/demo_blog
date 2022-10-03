class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true

      # Comment table
      t.references :commentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
