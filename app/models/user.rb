# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :name, presence: true

  has_many :following_users, dependent: :destroy
  has_many :followees, through: :following_users, source: :following_user
  has_many :followers, class_name: 'FollowingUser', foreign_key: :following_user_id, dependent: :destroy
  has_many :sleep_records, class_name: 'SleepRecord', dependent: :destroy
end
