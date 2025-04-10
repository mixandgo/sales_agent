class SubmissionsController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @submission = @chat.submissions.create(submission_params)
    # GenerateResponseJob.perform_later(@submission)
  end

  private

    def submission_params
      params.require(:submission).permit(:input)
    end
end
