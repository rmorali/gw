class SendMail
  def initialize(user,type)
    @user = user
    @type = type
  end

  def send!
    @users = User.all.reject! { |u| u.email == "setup@xws.com" || u.email == "setup@gw.com" }
    
    if @type == :status_change
      @users.each do |u|
        Mailer.status_change(u).deliver
      end   
    end

    if @type == :turn_change
      @users.each do |u|
        Mailer.turn_change(u).deliver
      end   
    end

  end

  private

end