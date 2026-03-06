class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.integer :value
      t.string :suit
      t.string :rank

      t.timestamps
    end
  end
end
