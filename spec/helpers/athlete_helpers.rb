require 'faker'
require 'factory_bot_rails'

module AthleteHelpers
  def create_athlete(user)
    FactoryBot.create(:athlete, 
      external_id: Faker::Lorem.characters(number: 10), 
      first_name: Faker::Name::first_name,
      last_name: Faker::Name::last_name,
      user: user
    )
  end

  def build_athlete(user)
    FactoryBot.build(:athlete, 
        external_id: Faker::Lorem.characters(number: 10), 
        first_name: Faker::Name::first_name,
        last_name: Faker::Name::last_name,
        user: user
      )
  end
end
