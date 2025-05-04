# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= User.find_by(id: request.headers['X-User-Id'])
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end
end
