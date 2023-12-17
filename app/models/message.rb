class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  validates :title, :body, presence: true

  scope :unread, -> { where(read: false) }
end