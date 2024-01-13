module RankingHelper
  def win_ratio(user)
    total_games = user.wins + user.losses + user.draws
    win_ratio = total_games > 0 ? (user.wins.to_f / total_games * 100).round(2) : 0.0
    "#{win_ratio}%"
  end
end