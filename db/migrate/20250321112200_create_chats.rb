class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :agent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
