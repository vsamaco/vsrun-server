# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "===== Starting DB Seed ====="

if (User.count === 0)
  user = User.create(email: 'foo@bar.com', password: 'foobar')
  puts "Created user: #{user.email}"
end

if (Athlete.count == 0)
  user = User.first
  athlete = Athlete.create(user: user, first_name: 'User', last_name: 'Test', external_id: SecureRandom.uuid)
  puts "Created athlete: #{athlete.id}"
end

if (Activity.count == 0)
  athlete = User.first.athlete
  activity = Activity.create(
    external_id: SecureRandom.uuid,
    name: 'Test Run',
    start_date: DateTime.now,
    moving_time: 180,
    distance: 5000,
    total_elevation_gain: 100, 
    athlete: athlete
  )
  puts "Created activity: #{activity.id}"
end

puts "===== End DB Seed ====="
