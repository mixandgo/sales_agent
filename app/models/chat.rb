class Chat < ApplicationRecord
  belongs_to :agent
  has_many :submissions, dependent: :destroy
  has_many :messages, through: :submissions
end
