# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClockOutController, type: :controller do
  include_context 'preload sleep record partition'

  let(:user) { create(:user) }
  let(:clock_in_time) { 8.hours.ago }
  let(:clock_out_worker) { ClockOutRecordWorker }

  before do
    allow(clock_out_worker).to receive(:perform_async)
    request.headers['X-User-Id'] = user.id.to_s
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      context 'when clock-out is successful' do
        let!(:sleep_record) { create(:sleep_record, user: user, clock_in: clock_in_time, date: clock_in_time.to_date) }

        it 'updates the sleep record with clock_out' do
          expect(clock_out_worker).to receive(:perform_async).once

          post :create

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when there is no active clock-in record' do
        it 'returns an error response' do
          post :create

          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to include('No active clock-in record found.')
        end
      end
    end

    context 'when user is not authenticated' do
      before { request.headers['X-User-Id'] = nil }

      it 'returns an unauthorized response' do
        post :create

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('Unauthorized')
      end
    end
  end
end
