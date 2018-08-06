class GamesController < ApplicationController
  def create
    @game = Game.create(game_params)
    json_response(@game, :created)
  end

  private

  def game_params
    params.permit(:user_name)
  end
end
