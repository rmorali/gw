class Mailer < ActionMailer::Base
  default :from => "rodrigo.morali@gmail.com"
  
  def registration_confirmation(user)
    @user = user
    attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end

  def test(user)
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.email}", :subject => "Teste enviado")
  end

  def status_change(user,user_changed)
    @user = user
    @user_changed = user_changed
    @users = User.all.reject! { |u| u.email == "setup@xws.com" || u.email == "setup@gw.com" }
    mail(:to => "#{@user.email}", :subject => "X-Wing Galactic Wars: atualizacao de status")
  end

  def turn_change(user)
    @user = user
    @users = User.all.reject! { |u| u.email == "setup@xws.com" || u.email == "setup@gw.com" }
    if Round.getInstance.move?
      @status = 'Prepare sua estrategia...' 
    else
      @status = 'Realize seus combates...'
    end
    mail(:to => "#{@user.email}", :subject => "X-Wing Galactic Wars: virada de turno")
  end

end
