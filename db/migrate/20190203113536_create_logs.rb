class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.references :user

      t.string    :tcontroller
      t.string    :taction
      t.string    :note

      t.timestamps
    end
  end
end
