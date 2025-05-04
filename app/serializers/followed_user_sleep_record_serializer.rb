# frozen_string_literal: true

class FollowedUserSleepRecordSerializer < ActiveModel::Serializer
  attributes :sleep_record, :user

  def sleep_record
    SleepRecordSerializer.new(object).as_json
  end

  def user
    user = instance_options[:user_hash][object.user_id]
    UserSerializer.new(user).as_json
  end
end
