class FacilityFleetsController < ApplicationController
  before_filter :find_resources, :only => [:new, :create]

  def index
  end

  def new
    @facility_fleet = FacilityFleet.new
  end

  def create
    @squad = current_squad
    @facility = GenericUnit.find(params[:facility_fleet][:generic_unit_id])
    @quantity = params[:facility_fleet][:quantity].to_i
    @success = nil
    if current_squad.credits >= @facility.price * @quantity
      current_squad.buy @facility, @quantity, @planet
      @success = true
    end
    GroupFleet.new(@planet).group!
  end


  def edit
    @facility = FacilityFleet.find(params[:id])
    @units = Unit.allowed_for(current_squad.faction)
    @planet = @facility.planet
    unless @facility.producing_unit.present?
      @producing_capacity = 0
      @current_producing_unit_status = 0
    end
  end

  def produce
    @facility = FacilityFleet.find(params[:unit][:facility])
    @squad = current_squad
    @planet = @facility.planet
    @unit = Unit.find(params[:unit][:id])
    @quantity = params[:unit][:quantity].to_i
    unless params[:unit][:quantity].to_i <= 0 || params[:unit][:id].empty? || current_squad.ready?
      @facility.produce! @unit, @quantity, @planet, @squad
    end
    redirect_to :back
  end

  def upgrade
    @facility = FacilityFleet.find(params[:facility][:id])
    @facility.upgrade! unless current_squad.credits < @facility.upgrade_cost || current_squad.ready?
    redirect_to :back
  end


  private
  def find_resources
    @planet = Planet.find params[:planet_id]
    @facilities = GenericUnit.allowed_for(current_squad.faction)
  end

end

