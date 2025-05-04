# frozen_string_literal: true

module SleepRecordCommands
  class QuerySleepRecords
    def initialize(user, params)
      @user = user
      @params = params
    end

    def perform
      sleep_records = Filters::SleepRecordFilter.new(sleep_record_params).execute
      Sorts::SleepRecordSort.new(sleep_records, @params).execute
    end

    private

    def sleep_record_params
      @params.slice(
        :user_ids,
        :clock_in_gt
      )
    end
  end
end
