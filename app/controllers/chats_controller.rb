class ChatsController < ApplicationController
  def index
    @agents = Agent.all
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
