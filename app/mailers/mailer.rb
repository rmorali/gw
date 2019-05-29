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

  def turn_alert(user)
    @user = user
    @users = User.all.reject! { |u| u.email == "setup@xws.com" || u.email == "setup@gw.com" }
    @users.each do |f|
      mail(:to => "#{f.email}", :subject => "X-Wing Galactic Wars: alteracao de status")
    end
  end

  def new_turn(status)
    @users = User.all.reject! { |u| u.email == "setup@xws.com" || u.email == "setup@gw.com" }
    @status = 'Prepare sua estrategia...' if status == 'estrategia'
    @status = 'Realize seus combates...' if status == 'combates'
    @users.each do |f|
      mail(:to => "#{f.email}", :subject => "X-Wing Galactic Wars: virada de turno")
    end
  end

end
