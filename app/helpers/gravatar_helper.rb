# frozen_string_literal: true

module GravatarHelper
  def user_avatar(user)
    "https://www.gravatar.com/avatar/#{user_gravatar_hash(user.email.to_s.downcase)}"
  end

  def user_gravatar_hash(email_address)
    return '0' * 32 if email_address.blank?

    Digest::MD5.hexdigest(email_address)
  end
end
