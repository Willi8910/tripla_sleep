# frozen_string_literal: true

module SleepRecordCommands
  class CreateClockIn
    def initialize(user)
      @user = user
    end

    def perform
      sleep_record = @user.sleep_records.create(clock_in: Time.current, date: Time.current.to_date)
      return unless sleep_record.persisted?

      sleep_record
    end
  end
end
