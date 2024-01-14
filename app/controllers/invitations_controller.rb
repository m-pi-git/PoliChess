class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sent_invitations = current_user.sent_invitations
    @received_invitations = current_user.received_invitations
  end

  def new
    @invitation = Invitation.new
    @invitation.receiver_email = params[:receiver_email]
    @invitation.receiver_id = params[:receiver_id]
  end
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user

    receiver = User.find_by(email: params[:invitation][:receiver_email])
    @invitation.receiver = receiver if receiver

    if @invitation.save
      redirect_to root_path, notice: 'Invitation sent successfully.'
    else
      puts @invitation.errors.full_messages # lub flash[:error] = 'Coś poszło nie tak...'
      render :new
    end
  end


  def accept
    invitation = Invitation.find(params[:id])
    @invitation = invitation
    invitation.accepted!
    render 'accepted', locals: { invitation: @invitation }
    # Tutaj przekieruj do akcji show w kontrolerze InvitationsController
    invitation.destroy
  end

  def decline
    invitation = Invitation.find(params[:id])
    invitation.destroy

    # Tutaj przekieruj do root_path
    redirect_to root_path, notice: 'Invitation declined.'
  end

  def received
    @received_invitations = current_user.received_invitations
  end

  private

  def invitation_params
    params.require(:invitation).permit(:receiver_email)
  end
end
