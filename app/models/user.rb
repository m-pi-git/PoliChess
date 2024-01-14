class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :playables
  has_many :games, through: :playables
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'sender_id'
  has_many :received_invitations, class_name: 'Invitation', foreign_key: 'receiver_id'

  has_one :profile

  accepts_nested_attributes_for :profile

  after_create :create_user_profile


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

end
