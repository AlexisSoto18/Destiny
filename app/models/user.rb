class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  def generate_password_reset_token!
    update!(
      password_reset_token: SecureRandom.urlsafe_base64,
      password_reset_sent_at: Time.current
    )
  end

  # Verifica que el token se haya generado recientemente (por ejemplo, en los últimos 15 minutos)
  def password_reset_token_valid?
    password_reset_sent_at && password_reset_sent_at > 15.minutes.ago
  end

  # Resetea la contraseña y limpia el token y la marca de tiempo
  def reset_password!(new_password, new_password_confirmation)
    if update(password: new_password, password_confirmation: new_password_confirmation)
      update(password_reset_token: nil, password_reset_sent_at: nil)
    end
  end
  
end
