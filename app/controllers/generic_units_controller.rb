# http://guides.rubyonrails.org/active_record_querying.html
class GenericUnitsController < ApplicationController
  def index
    @generic_units = GenericUnit.all
  end

  def update
    @generic_unit = GenericUnit.find(params[:id])
    @generic_unit.update_attributes(params[:generic_unit])
    @generic_unit.save
    redirect_to :generic_units
  end

  def ships
    @squad = Squad.find(params[:id])
    @generic_units = GenericUnit.select { |unit| unit.belongs?('nenhuma')  }
    @fleet = GenericUnit.select { |unit| unit.belongs? @squad.faction }
  end


  def add_to_squad
    @squad = current_squad
    @generic_unit = GenericUnit.find(params[:ships][:id])
    @generic_unit.factions=current_squad.faction
    @generic_unit.save
    redirect_to :controller => 'generic_units', :action => 'ships', :id => @squad.id 
  end

end
