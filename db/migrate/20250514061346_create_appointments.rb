class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
