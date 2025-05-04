# frozen_string_literal: true

module Sorts
  class SleepRecordSort
    include BaseSort

    private

    def permissible_sort_keys
      %w[created_at duration]
    end

    def by_default
      reflect(
        query.order('created_at DESC')
      )
    end

    def by_interval_duration
      reflect(
        query.order("interval_duration #{sort_order}")
      )
    end

    def by_created_at
      reflect(
        query.order("created_at #{sort_order}")
      )
    end
  end
end
