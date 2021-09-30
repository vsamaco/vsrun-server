class CreateAthletes < ActiveRecord::Migration[6.1]
  def change
    create_table :athletes do |t|
      t.string :external_id, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :users, :external_id,                unique: true
  end
end