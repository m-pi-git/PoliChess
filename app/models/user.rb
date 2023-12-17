class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :playables
  has_many :games, through: :playables

  has_one :profile
    has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
    has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'

  has_many :friendships
  has_many :friends, through: :friendships


  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]
  after_create :create_user_profile



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

  def create_user_profile
    # Używamy 6 pierwszych cyfr z emaila jako student_index
    student_index = email.scan(/\d/).first(6).join

    # Tworzymy profil dla użytkownika
    Profile.create(user: self, student_index: student_index, name: "", surname: "", email: email)
  end

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
