class CreateChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :chunks do |t|
      t.references :resource, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
