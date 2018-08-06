require 'rails_helper'

RSpec.describe PitchesController, type: :request do

  describe 'POST /games/:game_id/pitches' do
    let!(:game) { create(:game) }

    let(:valid_attributes) { attributes_for(:pitch, game_id: game.id).to_json }

    context 'when the request is valid' do
      before {
        post "/games/#{game.id}/pitches",
        params: valid_attributes,
        headers: { 'Content-Type': 'application/json' }
      }

      it 'creates a Pitch' do
        expect(json['pins_knocked_down']).to eq 1
        expect(json['game_id']).to eq game.id
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end
end
