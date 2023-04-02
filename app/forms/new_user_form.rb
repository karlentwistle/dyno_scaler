# frozen_string_literal: true

class NewUserForm
  include ActiveModel::Model

  attr_accessor :email, :password, :organisation_name, :remember_token

  def save
    organisation = Organisation.new(name: organisation_name)
    user = organisation.users.new(email:, password:)

    if [user, organisation].map(&:valid?).all? # evaluate validity of both models non lazily
      ActiveRecord::Base.transaction do
        user.save!
        organisation.save!
      end

      user
    else
      errors.merge!(user.errors)
      organisation.errors.messages_for(:name).each { |message| errors.add(:organisation_name, message) }

      false
    end
  end
end
