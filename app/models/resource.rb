class Resource < ApplicationRecord
  has_many :chunks, dependent: :destroy
end
