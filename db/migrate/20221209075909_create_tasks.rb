class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
    	t.string :title
    	t.text :description
    	t.integer :status,   default: 0
    	t.integer :priority, default: 0

    	t.references :user, index: true
    	t.references :project, index: true
    	t.references :assigne, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
