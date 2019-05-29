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
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    @users.each do |f|
      mail(:to => "#{f.email}", :subject => "X-Wing Galactic Wars: alerta de turno")
    end
  end

end
