# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller

  private

  def current_organisation
    @current_organisation ||= current_user.organisation
  end

  helper_method :current_organisation
end
