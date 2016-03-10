class SettingsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @settings = Setting.first
    @units = ['Facility','CapitalShip','LightTransport','Fighter','Trooper','Miner','Warrior']
  end

  def edit
    @settings = Setting.first
  end

  def update
    @settings = Setting.find(params[:id])
    @settings.update_attributes(params[:setting])
    @settings.save
    redirect_to :back
  end
end

