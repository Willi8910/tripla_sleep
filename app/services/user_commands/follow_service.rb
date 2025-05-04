# frozen_string_literal: true

module UserCommands
  class FollowService
    def initialize(user, target_user)
      @user = user
      @target_user = target_user
    end

    def perform
      return { error: 'Cannot follow yourself' } if @user == @target_user

      # Check if the user is already following the target user
      return { error: 'Already following this user' } if @user.following_users.exists?(following_user: @target_user)

      # Create the follow relationship
      @user.following_users.create(following_user: @target_user)
      { success: 'User followed successfully' }
    end
  end
end
