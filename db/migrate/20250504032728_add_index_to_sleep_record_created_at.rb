# frozen_string_literal: true

class AddIndexToSleepRecordCreatedAt < ActiveRecord::Migration[7.1]
  def change
    add_index :sleep_records, :created_at
  end
end
