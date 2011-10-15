class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :urgency
      t.integer :importance

      t.timestamps
    end
  end
end
