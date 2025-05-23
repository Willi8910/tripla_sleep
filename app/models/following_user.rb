# frozen_string_literal: true

# == Schema Information
#
# Table name: following_users
#
#  id                :uuid             not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  following_user_id :uuid             not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_following_users_on_following_user_id              (following_user_id)
#  index_following_users_on_user_id                        (user_id)
#  index_following_users_on_user_id_and_following_user_id  (user_id,following_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (following_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class FollowingUser < ApplicationRecord
  belongs_to :user
  belongs_to :following_user, class_name: 'User'

  validates :user_id, uniqueness: { scope: :following_user_id, message: 'You are already following this user' }
end
