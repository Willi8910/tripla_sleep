# frozen_string_literal: true

module Filters
  class SleepRecordFilter
    include BaseFilter

    attr_reader :init_records

    def initialize(params, init_records = SleepRecord.all)
      @init_records = init_records
      super(params)
    end

    private

    def base_query
      init_records
    end

    def permissible_filter_keys
      %i[user_ids clock_in_gt]
    end

    def by_user_ids
      user_ids = params[:user_ids]
      user_ids = user_ids.split(',') if user_ids.instance_of?(String)

      reflect(query.where(user_id: user_ids))
    end

    def by_clock_in_gt
      reflect(query.where('clock_in >= ?', params[:clock_in_gt]))
    end
  end
end
