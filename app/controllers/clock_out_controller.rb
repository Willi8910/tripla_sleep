# frozen_string_literal: true

class ClockOutController < ApplicationController
  before_action :authenticate_user!

  def create
    result = SleepRecordCommands::ClockOutRecord.new(current_user).perform

    if result[:success].present?
      head :ok
    else
      render_failed(result[:error])
    end
  end
end
