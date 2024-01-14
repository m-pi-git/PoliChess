class MessagesController < ApplicationController
  before_action :set_message, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @sent_messages = current_user.sent_messages
    @received_messages = current_user.received_messages
  end
  def show
    @message = Message.find_by(id: params[:id])
  end

  def new
    @message = Message.new
    @message.receiver_email = params[:receiver_email]
    @message.receiver_id = params[:receiver_id]
  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.sent = true

    receiver = User.find_by(email: params[:message][:receiver_email])
      @message.receiver = receiver if receiver


      if @message.save
         redirect_to new_message_path, notice: 'Message was successfully sent.'
      else
        flash[:alert] = "Incorrect email"
        redirect_to new_message_path
    end
  end
  def received
    @received_messages = current_user.received_messages
  end

  def sent
    @sent_messages = current_user.sent_messages
  end

  def destroy
    @message.destroy
     redirect_to messages_path, notice: 'Message was successfully deleted.'
  end

  private

  def set_message
      @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:receiver_email, :title, :body)
  end
end
