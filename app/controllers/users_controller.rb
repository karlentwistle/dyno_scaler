# frozen_string_literal: true

class UsersController < Clearance::BaseController
  before_action :redirect_signed_in_users, only: %i[create new]
  skip_before_action :require_login, only: %i[create new], raise: false

  def new
    @form = NewUserForm.new
    render template: 'users/new'
  end

  def create
    @form = NewUserForm.new(form_params)

    if (user = @form.save)
      sign_in user
      redirect_back_or url_after_create
    else
      render template: 'users/new', status: :unprocessable_entity
    end
  end

  private

  def redirect_signed_in_users
    return unless signed_in?

    redirect_to Clearance.configuration.redirect_url
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def form_params
    params.expect(new_user_form: %i[email password organisation_name])
  end
end
