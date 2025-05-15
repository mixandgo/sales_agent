# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  submission_id :integer          not null
#  role          :string
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_messages_on_submission_id  (submission_id)
#

class Message < ApplicationRecord
  belongs_to :submission

  def agent?
    role == "assistant"
  end
end
