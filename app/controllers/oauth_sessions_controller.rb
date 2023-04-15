# frozen_string_literal: true

class OauthSessionsController < ApplicationController
  def create
    sign_in user

    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def user
    @user ||= User.find_or_create_from_auth_hash(auth_hash)
  end
end
