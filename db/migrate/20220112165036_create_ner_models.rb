class CreateNerModels < ActiveRecord::Migration[6.1]
  def change
    create_table :ner_models do |t|
      t.boolean :public
      t.string :title
      t.text :description
      t.string :language
      t.string :transkribus_user_id
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
