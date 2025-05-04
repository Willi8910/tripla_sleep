# frozen_string_literal: true

class AddUserIdIndexSleepRecord < ActiveRecord::Migration[7.1]
  def change
    add_index :sleep_records, :user_id
  end
end
