# frozen_string_literal: true

class GenerateSleepRecordPartitionWorker
  include Sidekiq::Worker

  def perform(start_date = Date.today)
    start_date = start_date.beginning_of_month
    end_date = (start_date >> 1) # Add 1 month
    partition_name = "sleep_records_#{start_date.strftime('%Y_%m')}"

    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS #{partition_name} PARTITION OF sleep_records
      FOR VALUES FROM ('#{start_date}') TO ('#{end_date}');
    SQL
  end
end
