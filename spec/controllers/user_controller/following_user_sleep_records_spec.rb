# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:following_user) { create(:user) }
  let!(:following_user2) { create(:user) }
  let!(:non_following_user) { create(:user) }

  before do
    create_partition(1.month.ago.to_date)
    create_partition(Date.today)
  end

  def create_partition(input_date)
    start_date = input_date.beginning_of_month
    end_date = (start_date >> 1) # Add 1 month
    partition_name = "sleep_records_#{start_date.strftime('%Y_%m')}"

    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS #{partition_name} PARTITION OF sleep_records
      FOR VALUES FROM ('#{start_date}') TO ('#{end_date}');
    SQL
  end

  before do
    request.headers['X-User-Id'] = user.id.to_s
    user.following_users.create(following_user:)
    user.following_users.create(following_user: following_user2)
    create(:sleep_record, user: following_user, date: 2.days.ago.to_date, clock_in: 2.days.ago,
                          time_duration: 2.days.ago..(1.day.ago), interval_duration: 86_400)
    create(:sleep_record, user: following_user2, date: 5.days.ago.to_date, clock_in: 5.days.ago,
                          time_duration: 5.days.ago..(3.days.ago), interval_duration: 172_800)
    create(:sleep_record, user: non_following_user, date: 4.days.ago.to_date, clock_in: 4.days.ago,
                          time_duration: 4.days.ago..(1.day.ago))
  end

  describe 'GET #following_user_sleep_records' do
    it 'returns sleep records of following users from the last week, sorted by duration' do
      get :following_user_sleep_records
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)

      expect(json_response.first['sleep_record']['interval_duration']).to eq(172_800)
      expect(json_response.first['user']['id']).to eq(following_user2.id)

      expect(json_response.last['sleep_record']['interval_duration']).to eq(86_400)
      expect(json_response.last['user']['id']).to eq(following_user.id)
    end
  end
end
