# frozen_string_literal: true

class NewUserForm
  include ActiveModel::Model

  attr_accessor :email, :password, :organisation_name, :remember_token

  def save
    if [user, organisation].map(&:valid?).all? # evaluate validity of both models non lazily
      ActiveRecord::Base.transaction do
        user.save!
        organisation.save!
        user.add_role :manager, organisation
      end

      user
    else
      errors.merge!(user.errors)
      organisation.errors.messages_for(:name).each { |message| errors.add(:organisation_name, message) }

      false
    end
  end

  private

  def organisation
    @organisation ||= initialize_organisation
  end

  def initialize_organisation
    Organisation.new(
      name: organisation_name,
      hosted_domain: extract_organisation_hosted_domain_from_email
    )
  end

  def extract_organisation_hosted_domain_from_email
    Mail::Address.new(email).domain
  end

  def user
    @user ||= organisation.users.new(email:, password:)
  end
end
