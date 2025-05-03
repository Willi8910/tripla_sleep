# frozen_string_literal: true

class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pg_partman' unless extension_enabled?('pg_partman')
    enable_extension 'btree_gist' unless extension_enabled?('btree_gist')

    execute <<-SQL
      CREATE TABLE sleep_records (
        id UUID DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL,
        clock_in TIMESTAMPTZ NOT NULL,
        interval_duration INTERVAL,
        time_duration TSTZRANGE,
        date DATE NOT NULL,
        created_at TIMESTAMPTZ NOT NULL,
        updated_at TIMESTAMPTZ NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      ) PARTITION BY RANGE (date);
    SQL

    add_index :sleep_records, :interval_duration
    add_index :sleep_records, :clock_in
    add_index :sleep_records, :time_duration, using: :gist
  end
end
