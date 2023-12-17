class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]


  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize_to_fill: [200, 200]).processed
    else
      '/default_profile.jpg'
    end
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
