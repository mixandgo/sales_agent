class Message < ApplicationRecord
  belongs_to :submission

  def agent?
    role == "assistant"
  end
end
