class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :playables
  has_many :games, through: :playables
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]


  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize_to_fill: [200, 200]).processed
    else
      '/default_profile.jpg'
    end
  end
  def game_in_progress_with(target_user)
    games
      .where(id: target_user.games)
      .where(state: :in_progress)
  end

  private
  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'default_profile.jpg'
          )
        ),
        filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
    end
  end
end
