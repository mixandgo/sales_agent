class Agent < ApplicationRecord
  has_many :chats, dependent: :destroy
end
