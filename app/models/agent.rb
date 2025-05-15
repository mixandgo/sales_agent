# == Schema Information
#
# Table name: agents
#
#  id            :integer          not null, primary key
#  name          :string
#  system_prompt :text
#  model         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text
#

class Agent < ApplicationRecord
  has_many :chats, dependent: :destroy
end
