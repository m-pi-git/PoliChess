# app/controllers/ranking_controller.rb
class RankingController < ApplicationController
  include RankingHelper

  def index
    @users = User.order(wins: :desc, losses: :asc, draws: :asc).all
  end
end
