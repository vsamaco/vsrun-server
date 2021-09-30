class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :external_id, null: false
      t.string :name
      t.string :activity_type
      t.datetime :start_date
      t.json :laps
      t.json :splits
      t.json :map
      t.decimal :distance
      t.decimal :moving_time
      t.decimal :elapsed_time
      t.decimal :total_elevation_gain
      t.decimal :start_latitude
      t.decimal :start_longitude
      t.string :start_latlong
      t.decimal :end_latitude
      t.decimal :end_longitude
      t.string :end_latlong
      t.string :external_gear_id
      t.string :external_athlete_id

      t.references :athlete, references: :athletes, foreign_key: true
      t.timestamps
    end
  end
end
