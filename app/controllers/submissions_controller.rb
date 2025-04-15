class SubmissionsController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @submission = @chat.submissions.create(submission_params)
    AssistantResponseJob.perform_later(chat: @chat, submission: @submission)
  end

  private

    def submission_params
      params.require(:submission).permit(:input)
    end
end
