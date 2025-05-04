# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClockOutRecordWorker, type: :worker do
  include_context 'preload sleep record partition'

  describe '#perform' do
    let(:clock_in_time) { Time.zone.now - 1.day }
    let(:clock_out_time) { Time.zone.now }
    let(:sleep_record) do
      create(:sleep_record, clock_in: clock_in_time, date: clock_in_time.to_date, user: create(:user))
    end

    it 'updates the sleep_record with time_duration and interval_duration' do
      described_class.new.perform(sleep_record.user_id, clock_out_time.to_s)

      last_sleep_record = SleepRecord.where(user: sleep_record.user).order(created_at: :desc).first
      expect(last_sleep_record.interval_duration).to be_truthy
      expect(last_sleep_record.time_duration).to be_truthy
    end
  end
end
