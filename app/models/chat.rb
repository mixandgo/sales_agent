class Chat < ApplicationRecord
  belongs_to :agent
  has_many :submissions, dependent: :destroy
end
