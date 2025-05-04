# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClockInController, type: :controller do
  include_context 'preload sleep record partition'

  let!(:user) { create(:user) }
  let(:headers) { { 'X-User-Id' => user.id.to_s } }

  describe 'POST #create' do
    context 'when user is authenticated' do
      before do
        request.headers.merge!(headers)
        create(:sleep_record, user:, clock_in: Time.current - 1.day)
      end

      context 'when successfully clock in' do
        it 'creates a new sleep record and returns the list of all clocked-in records' do
          post :create
          expect(response).to have_http_status(:created)

          json_response = JSON.parse(response.body)
          expect(json_response).to be_an_instance_of(Array)
          expect(json_response.size).to be > 1

          initial_record = SleepRecord.find_by(user:, clock_in: ..Time.current)
          expect(json_response.map { |record| record['id'] }).to include(initial_record.id)
        end
      end

      context 'when the clock-in fails' do
        before do
          # Simulate a service failure by stubbing `ClockInService` to raise an error
          allow_any_instance_of(SleepRecordCommands::CreateClockIn)
            .to receive(:perform)
            .and_return(OpenStruct.new(success?: false, errors: ['Clock-in failed']))
        end

        it 'returns an error response with a 422 status' do
          post :create

          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Failed to clock in')
        end
      end
    end

    context 'when user is not authenticated' do
      it 'returns a 401 unauthorized status' do
        # No headers set here
        post :create
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
