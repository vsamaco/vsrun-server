class CreateAthletes < ActiveRecord::Migration[6.1]
  def change
    create_table :athletes do |t|
      t.string :external_id, null: false
      t.string :first_name
      t.string :last_name
      t.json   :shoes

      t.timestamps
    end

    add_index :athletes, :external_id,                unique: true
  end
end
