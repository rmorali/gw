class Warrior < Unit

  def maximum_lives
    settings = Setting.getInstance
    settings.maximum_warrior_life
  end

end
