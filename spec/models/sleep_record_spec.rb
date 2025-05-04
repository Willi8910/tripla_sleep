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
require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      clock_in: Time.current,
      date: Date.current,
      user_id: user.id
    }
  end

  describe 'factory' do
    it 'should have a valid factory' do
      expect(build(:sleep_record, user_id: user.id, date: Date.today, clock_in: Time.zone.now)).to be_valid
    end
  end

  describe 'creating a valid SleepRecord' do
    it 'is valid with valid attributes' do
      sleep_record = SleepRecord.new(valid_attributes)
      expect(sleep_record).to be_valid
    end
  end

  describe 'invalid SleepRecord' do
    it 'is invalid without a clock_in' do
      sleep_record = SleepRecord.new(valid_attributes.except(:clock_in))
      expect(sleep_record).to_not be_valid
    end

    it 'is invalid without a date' do
      sleep_record = SleepRecord.new(valid_attributes.except(:date))
      expect(sleep_record).to_not be_valid
    end
  end

  describe 'indexing' do
    it 'has an index on clock_in' do
      expect(SleepRecord.connection.indexes('sleep_records').map(&:columns)).to include(['clock_in'])
    end

    it 'has an index on interval_duration' do
      expect(SleepRecord.connection.indexes('sleep_records').map(&:columns)).to include(['interval_duration'])
    end

    it 'has a GiST index on time_duration' do
      index = SleepRecord.connection.indexes('sleep_records').find { |idx| idx.columns.include?('time_duration') }
      expect(index).to_not be_nil
      expect(index.using).to eq(:gist)
    end
  end
end
