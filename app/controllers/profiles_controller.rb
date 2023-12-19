class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[ show edit update destroy ]

  def index
    @profiles = Profile.all
  end

  def create
    @profile = Profile.new(profile_params)
  end


  def update
      if @profile.update(profile_params)
       redirect_to profile_url(@profile), notice: "Profile was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end

  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end


  def profile_params
    params.require(:profile).permit(:index, :name, :surname, :mail, :avatar)
  end

end


