require 'my_strava'

namespace :strava do
  desc 'Import athlete'
  task :import_athlete, [:run] => :environment do |_t, args|
    Rails.logger = Logger.new(STDOUT)

    args.with_defaults(:run => false)
    options = {
      run: ActiveRecord::Type::Boolean.new.cast(args[:run])
    }
    Rails.logger.debug "=== Import Athlete #{options} ==="
    result = MyStrava::Athlete::import(options)
  end

  desc 'Fetch activities'
  task :fetch_activities => :environment do |_t, args|
    Rails.logger = Logger.new(STDOUT)
    args.with_defaults(:run => false)
    options = {
      run: ActiveRecord::Type::Boolean.new.cast(args[:run])
    }

    activities = MyStrava::Activity::fetch_new_activities(options)
    Rails.logger.debug "=== Fetch Activities #{options} ===="
    activities.each do |activity|
      Rails.logger.debug "#{activity.id} #{activity.name} #{activity.start_date}"
    end
    Rails.logger.debug "New Activities: #{activities.count}"
  end

  desc 'Import activities'
  task :import_activities, [:activity_ids, :run] => :environment do |_t, args|
    Rails.logger = Logger.new(STDOUT)
    args.with_defaults(:activity_ids => '', :run => false)
    options = {
      activity_ids: args[:activity_ids].split(' '),
      run: ActiveRecord::Type::Boolean.new.cast(args[:run])
    }

    activities = MyStrava::Activity::fetch_new_activities(options)
    selected_activities = activities.select {|a| options[:activity_ids].include?(a.id.to_s)}

    Rails.logger.debug "=== Import Activities #{options} ===="
    if selected_activities.count > 0 || (options[:run] && selected_activities.count > 0)
      result = MyStrava::Activity::import_activities(
        options.merge({activities: selected_activities})
      )
    end
  end
end
