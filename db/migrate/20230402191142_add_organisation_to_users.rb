# frozen_string_literal: true

class AddOrganisationToUsers < ActiveRecord::Migration[7.0]
  class LocalUser < ApplicationRecord
    self.table_name = 'users'
  end

  class LocalOrganisation < ApplicationRecord
    self.table_name = 'organisations'
  end

  def up
    add_reference :users, :organisation, foreign_key: true

    LocalUser.find_each do |user|
      hosted_domain = Mail::Address.new(user.email).domain
      organisation = LocalOrganisation.find_or_create_by(name: 'Default', hosted_domain:)
      user.update!(organisation_id: organisation.id)
    end

    change_column_null :users, :organisation_id, false
  end

  def down
    remove_reference :users, :organisation
  end
end
