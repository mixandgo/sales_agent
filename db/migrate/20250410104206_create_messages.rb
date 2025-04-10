class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :submission, null: false, foreign_key: true
      t.string :role
      t.text :body

      t.timestamps
    end
  end
end
