# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller

  def current_organization
    @current_organization ||= current_user.organisation
  end
end
