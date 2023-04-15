# frozen_string_literal: true

class CreateOrganisations < ActiveRecord::Migration[7.0]
  def change
    create_table :organisations do |t|
      t.string :name, null: false
      t.string :hosted_domain, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
