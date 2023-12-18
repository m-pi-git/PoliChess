class FriendsController < ApplicationController
  before_action :authenticate_user!


  def index
    @friends = current_user.friends #Wyświetlanie
  end

  #Dodawanie do listy
  def create
    email = params[:email]
    friend = User.find_by(email: email)

    if friend && !current_user.friends.include?(friend) && friend != current_user
      current_user.friends << friend
      flash[:notice] = "Friend added successfully."
    elsif friend == current_user
      flash[:alert] = "You cannot add yourself as a friend."
    elsif current_user.friends.include?(friend)
      flash[:alert] = "User is already your friend."
    else
      flash[:alert] = "User not found."
    end
    redirect_to friends_path
    end
    def destroy
      # Kod usuwający znajomego z listy
      friend = User.find(params[:id])
      current_user.friends.destroy(friend)
      flash[:notice] = "Friend removed successfully."
      redirect_to friends_path
    end


  end


