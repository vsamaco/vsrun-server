require 'faker'
require 'factory_bot_rails'

module AthleteHelpers
  def create_athlete
    FactoryBot.create(:athlete, 
            external_id: Faker::String.random(length: 6), 
            first_name: Faker::Name::first_name,
            last_name: Faker::Name::last_name
        )
  end

    def build_athlete
      FactoryBot.build(:user, 
          external_id: Faker::String.random(length: 6), 
          first_name: Faker::Name::first_name,
          last_name: Faker::Name::last_name
        )
  end
end