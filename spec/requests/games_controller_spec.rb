require 'rails_helper'

RSpec.describe GamesController, type: :request do
  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:game) }

    context 'when the request is valid' do
      before { post '/games', params: valid_attributes }

      it 'creates a Game' do
        expect(json['user_name']).to eq('User')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end
end
