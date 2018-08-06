require 'rails_helper'

RSpec.describe GamesController, type: :request do
  describe 'POST /games' do
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

  describe 'GET /games/:id' do
    let!(:game) { create(:game) }

    before { get "/games/#{game.id}" }

    context 'when the Game exist' do
      it 'returns the Game' do
        expect(json).not_to be_empty
        expect(json['id']).to eq game.id
      end

      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
