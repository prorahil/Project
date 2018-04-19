class CreateInstructors < ActiveRecord::Migration[5.1]
  def change
    create_table :instructors do |t|
      t.string :first_name
      t.string :last_name
      t.text :bio
      t.boolean :active
      t.integer :user_id

      t.timestamps
    end
  end
end
