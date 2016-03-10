class Facility < GenericUnit
 
  def capacity
    settings = Setting.getInstance
    (self.price / 100 * settings.facility_primary_production_rate).to_i
  end

end

