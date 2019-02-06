class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :user

      t.string    :title
      t.string    :body
      t.integer   :state
      t.datetime  :app_time

      t.timestamps

      # t.index ['user_id', 'state'], name: 'user_id_state_unique', unique: true
    end
  end
end
