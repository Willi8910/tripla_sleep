# frozen_string_literal: true

class ClockInController < ApplicationController
  before_action :authenticate_user!

  def index
    sleep_records = SleepRecordCommands::QuerySleepRecords.new(current_user, params).perform
    render json: sleep_records, each_serializer: SleepRecordSerializer
  end

  def create
    sleep_record = SleepRecordCommands::CreateClockIn.new(current_user).perform

    if sleep_record.persisted?
      sleep_record_params = {
        sort_by: :created_at,
        sort_oder: :desc,
        user_ids: current_user.id
      }
      sleep_records = SleepRecordCommands::QuerySleepRecords.new(current_user, sleep_record_params).perform
      render json: sleep_records, each_serializer: SleepRecordSerializer, status: :created
    else
      render_failed('Failed to clock in')
    end
  end
end
