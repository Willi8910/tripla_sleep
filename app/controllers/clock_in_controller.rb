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
      sleep_records = SleepRecordCommands::QuerySleepRecords.new(current_user, { created_at: :desc }).perform
      render json: sleep_records, status: :created
    else
      render_failed('Failed to clock in')
    end
  end
end
