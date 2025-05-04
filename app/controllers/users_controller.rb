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

  def following_user_sleep_records
    following_sleep_record_params = {
      user_ids: current_user.following_users.pluck(:following_user_id),
      clock_in_gt: 1.week.ago,
      sort_by: :interval_duration,
      sort_order: :desc
    }
    sleep_records = SleepRecordCommands::QuerySleepRecords.new(current_user, following_sleep_record_params)
                                                          .perform
    user_hash = User.where(id: current_user.following_users.pluck(:following_user_id)).index_by(&:id)
    render json: sleep_records, each_serializer: FollowedUserSleepRecordSerializer,
           user_hash: user_hash, status: :ok
  end
end
