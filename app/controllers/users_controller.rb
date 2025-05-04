# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def follow
    target_user = User.find(params[:id])
    result = UserCommands::FollowService.new(current_user, target_user).perform

    if result[:error]
      render_failed(result[:error])
    else
      render_success(result[:success])
    end
  end

  def unfollow
    target_user = User.find(params[:id])
    result = UserCommands::UnfollowService.new(current_user, target_user).perform

    if result[:error]
      render_failed(result[:error])
    else
      render_success(result[:success])
    end
  end
end
