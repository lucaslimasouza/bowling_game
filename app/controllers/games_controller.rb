class GamesController < ApplicationController
  def create
    @game = Game.create(JSON.parse(request.body.read))
    json_response(@game, :created)
  end

  def show
    @game = Game.find(params[:id])
    json_response(@game)
  end
end
