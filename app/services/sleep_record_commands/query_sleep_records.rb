# frozen_string_literal: true

module SleepRecordCommands
  class QuerySleepRecords
    def initialize(user, params)
      @user = user
      @params = params
    end

    def perform
      Sorts::SleepRecordSort.new(@user.sleep_records, @params).execute
    end
  end
end
