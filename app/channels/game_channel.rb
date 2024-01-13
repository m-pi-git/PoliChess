class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "game_#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play_move(data)
    game = Game.find(params[:game_id])

    game.turn = if game.turn == :white
                  :black
                else
                  :white
                end
    # convert string to enum
    game.state = Game.states[data['state']] if data['state']

    game.fen = data['fen']

    game.pgn = data['pgn']

    update_user_stats(game)

    game.save
    data['turn'] = game.turn

    ActionCable.server.broadcast("game_#{params[:game_id]}", data)
  end

  private

  def update_user_stats(game)
    white_player = User.find(game.white_player_id)
    black_player = User.find(game.black_player_id)

    case game.state.to_sym
    when :checkmate
      if game.turn == 'white'
        white_player.update(wins: white_player.wins + 1)
        black_player.update(losses: black_player.losses + 1)

      else

        white_player.update(losses: white_player.losses + 1)
        black_player.update(wins: black_player.wins + 1)
      end
    when :draw
      white_player.update(draws: white_player.draws + 1)
      black_player.update(draws: black_player.draws + 1)
    end
  end

end
