class AddDescriptionToAgents < ActiveRecord::Migration[8.0]
  def change
    add_column :agents, :description, :text
  end
end
