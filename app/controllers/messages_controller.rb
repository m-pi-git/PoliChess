class MessagesController < ApplicationController
  before_action :set_message, only: %i[show edit update destroy]


  before_action :authenticate_user!

  def index
    @sent_messages = current_user.sent_messages
    @received_messages = current_user.received_messages
  end
  def show
    @message = Message.find_by(id: params[:id])

    # Sprawdź, czy wiadomość została znaleziona
    unless @message
      flash[:alert] = 'Message not found.'
      redirect_to messages_path
      return
    end

    # Sprawdź, czy użytkownik ma dostęp do tej wiadomości
    unless @message.sender == current_user || @message.receiver == current_user
      flash[:alert] = 'You do not have access to this message.'
      redirect_to messages_path
    end
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

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  def received
    @received_messages = current_user.received_messages
  end

  def sent
    @sent_messages = current_user.sent_messages
  end


  def update
    # ... (jeśli będzie potrzebne)
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:receiver_email, :title, :body)
  end
end
