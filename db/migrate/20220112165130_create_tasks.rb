class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :status
      t.jsonb :parameters
      t.string :transkribus_user_id
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
