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
require 'rails_helper'

RSpec.describe FollowingUser, type: :model do
  let(:user) { User.create!(name: 'User A') }
  let(:followee) { User.create!(name: 'User B') }

  it 'is valid with valid attributes' do
    following_user = FollowingUser.new(user: user, following_user: followee)
    expect(following_user).to be_valid
  end

  it 'is invalid without a user' do
    following_user = FollowingUser.new(user: nil, following_user: followee)
    expect(following_user).not_to be_valid
  end

  it 'is invalid without a following_user' do
    following_user = FollowingUser.new(user: user, following_user: nil)
    expect(following_user).not_to be_valid
  end

  it 'prevents duplicate following relationships' do
    FollowingUser.create!(user: user, following_user: followee)
    duplicate = FollowingUser.new(user: user, following_user: followee)
    expect(duplicate).not_to be_valid
  end
end
