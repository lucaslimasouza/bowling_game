class PitchesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    frame = @game.current_frame
    body = JSON.parse(request.body.read)
    frame.pitches.build(pins_knocked_down: body['pins_knocked_down'], game: @game)
    frame.save
    @game.save
    json_response(@game.pitches.last, :created)
  end
end
