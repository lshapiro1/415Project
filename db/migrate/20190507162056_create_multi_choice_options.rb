class CreateMultiChoiceOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :multi_choice_options do |t|
      t.string :value
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
