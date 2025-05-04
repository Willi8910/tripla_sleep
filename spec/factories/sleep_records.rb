# frozen_string_literal: true

# == Schema Information
#
# Table name: sleep_records
#
#  id                :uuid
#  clock_in          :timestamptz      not null
#  date              :date             not null
#  interval_duration :interval
#  time_duration     :tstzrange
#  created_at        :timestamptz      not null
#  updated_at        :timestamptz      not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_sleep_records_on_clock_in           (clock_in)
#  index_sleep_records_on_created_at         (created_at)
#  index_sleep_records_on_interval_duration  (interval_duration)
#  index_sleep_records_on_time_duration      (time_duration) USING gist
#  index_sleep_records_on_user_id            (user_id)
#
# Foreign Keys
#
#  sleep_records_user_id_fkey  (user_id => users.id)
#
FactoryBot.define do
  factory :sleep_record do
    clock_in { Time.current }
    date { Date.current }
    interval_duration { nil }
    time_duration { nil }
    user_id { SecureRandom.uuid }
  end
end
