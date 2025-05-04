# frozen_string_literal: true

module UserCommands
  class UnfollowService
    def initialize(user, target_user)
      @user = user
      @target_user = target_user
    end

    def perform
      return { error: 'Cannot unfollow yourself' } if @user == @target_user

      # Check if the user is following the target user
      follow_record = @user.following_users.find_by(following_user: @target_user)
      if follow_record
        follow_record.destroy
        { success: 'User unfollowed successfully' }
      else
        { error: 'Not following this user' }
      end
    end
  end
end
