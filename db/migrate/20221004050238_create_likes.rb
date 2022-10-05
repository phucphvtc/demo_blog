class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true

      t.integer :liked, default: 0

      t.references :liketable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
