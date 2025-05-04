# frozen_string_literal: true

class ClockOutRecordWorker
  include Sidekiq::Worker

  def perform(user_id, clock_out_time)
    user = User.find user_id
    sleep_record = user.sleep_records.where(interval_duration: nil).order(:clock_in).last

    clock_out_time = clock_out_time.to_datetime
    interval_duration = clock_out_time.in_time_zone - sleep_record.clock_in

    SleepRecord.where(clock_in: sleep_record.clock_in, user: user).update_all(
      time_duration: sleep_record.clock_in..clock_out_time,
      interval_duration: interval_duration.to_i
    )
  end
end
