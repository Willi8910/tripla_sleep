# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:target_user) { create(:user) }

  before do
    request.headers['X-User-Id'] = user.id.to_s
  end

  describe 'POST #follow' do
    it 'follows a user' do
      post :follow, params: { id: target_user.id }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq('User followed successfully')
    end

    it 'returns an error when trying to follow oneself' do
      post :follow, params: { id: user.id }
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Cannot follow yourself')
    end
  end
end
