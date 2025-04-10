class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.text :input
      t.text :context
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
