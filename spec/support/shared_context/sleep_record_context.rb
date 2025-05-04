# frozen_string_literal: true

RSpec.shared_context 'preload sleep record partition' do
  before do
    create_partition(1.month.ago.to_date)
    create_partition(Date.today)
  end

  def create_partition(input_date)
    start_date = input_date.beginning_of_month
    end_date = (start_date >> 1) # Add 1 month
    partition_name = "sleep_records_#{start_date.strftime('%Y_%m')}"

    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS #{partition_name} PARTITION OF sleep_records
      FOR VALUES FROM ('#{start_date}') TO ('#{end_date}');
    SQL
  end
end
