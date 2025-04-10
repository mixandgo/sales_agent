class CreateAgents < ActiveRecord::Migration[8.0]
  def change
    create_table :agents do |t|
      t.string :name
      t.text :system_prompt
      t.text :model

      t.timestamps
    end
  end
end
