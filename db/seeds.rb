# frozen_string_literal: true

def create_partition(input_date)
  start_date = input_date.beginning_of_month
  end_date = (start_date >> 1) # Add 1 month
  partition_name = "sleep_records_#{start_date.strftime('%Y_%m')}"

  ActiveRecord::Base.connection.execute(<<-SQL)
    CREATE TABLE IF NOT EXISTS #{partition_name} PARTITION OF sleep_records
    FOR VALUES FROM ('#{start_date}') TO ('#{end_date}');
  SQL
end

create_partition(1.month.ago.to_date)
create_partition(Date.today)

users = 5.times.map do |i|
  User.create!(name: "User #{i + 1}")
end

users.each do |user|
  # Each user follows 2-3 other users (excluding themselves)
  following_users = users.reject { |u| u == user }.sample(rand(2..3))
  following_users.each do |following_user|
    FollowingUser.create!(user: user, following_user: following_user)
  end
end

users.each do |user|
  3.times do |i|
    clock_in_time = rand(1..7).days.ago
    clock_out_time = clock_in_time + rand(1..8).hours
    SleepRecord.create!(
      user: user,
      date: clock_in_time.to_date,
      clock_in: clock_in_time,
      interval_duration: clock_out_time - clock_in_time,
      time_duration: clock_in_time..clock_out_time
    )
  end
end

puts "Seed data created successfully."
