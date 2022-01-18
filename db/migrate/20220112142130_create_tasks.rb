class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :status
      t.jsonb :parameters
      t.timestamps
    end
  end
end
