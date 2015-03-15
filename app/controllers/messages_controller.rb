class MessagesController < ApplicationController
  def new
  end

  def create
    @message = Message.create!(params.require(:message).permit(:message, :username))
    @message.save

    redirect_to freedomwall_index_path
  end
end
