class CreateBuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :builds do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cpu
      t.string :main
      t.string :psu
      t.string :cooler
      t.string :ssd
      t.string :ram 
      t.string :gpu 
      t.string :hdd 
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
