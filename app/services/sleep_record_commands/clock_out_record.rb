# frozen_string_literal: true

module SleepRecordCommands
  class ClockOutRecord
    def initialize(user)
      @user = user
    end

    def perform
      sleep_record = @user.sleep_records.where(interval_duration: nil).order(:clock_in).last

      return { error: 'No active clock-in record found.' } if sleep_record.nil?

      ClockOutRecordWorker.perform_async(sleep_record.user_id, Time.zone.now.to_s)

      { success: 'Succesfully Clock out record' }
    end
  end
end
