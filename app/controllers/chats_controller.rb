class ChatsController < ApplicationController
  def index
    @agent = Agent.first
  end

  def create
    @agent = Agent.find(params[:agent_id])
    @chat = @agent.chats.create!
    redirect_to chat_path(@chat)
  end

  def show
    @chat = Chat.find(params[:id])
    # @submissions = @chat.submissions.includes(:messages)
  end
end
