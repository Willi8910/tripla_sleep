# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateSleepRecordPartitionWorker, type: :worker do
  describe '#perform' do
    let(:worker) { described_class.new }

    it 'creates a partition table with the correct SQL for the given date' do
      date = Date.new(2024, 5, 1)
      partition_name = 'sleep_records_2024_05'
      start_date = date.beginning_of_month
      end_date = (start_date >> 1)

      expected_sql = <<-SQL
      CREATE TABLE IF NOT EXISTS #{partition_name} PARTITION OF sleep_records
      FOR VALUES FROM ('#{start_date}') TO ('#{end_date}');
      SQL

      connection = instance_double('ActiveRecord::Connection')
      allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
      expect(connection).to receive(:execute).with(expected_sql)

      worker.perform(date)
    end

    it 'uses Date.today as default when no date is given' do
      today = Date.today.beginning_of_month
      next_month = (today >> 1)
      partition_name = "sleep_records_#{today.strftime('%Y_%m')}"

      expected_sql = <<-SQL
      CREATE TABLE IF NOT EXISTS #{partition_name} PARTITION OF sleep_records
      FOR VALUES FROM ('#{today}') TO ('#{next_month}');
      SQL

      connection = instance_double('ActiveRecord::Connection')
      allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
      expect(connection).to receive(:execute).with(expected_sql)

      worker.perform
    end
  end
end
