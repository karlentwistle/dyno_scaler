# frozen_string_literal: true

class AddOrganisationToPipelines < ActiveRecord::Migration[7.0]
  class LocalUser < ApplicationRecord
    self.table_name = 'users'

    belongs_to :organisation, class_name: 'LocalOrganisation'
  end

  class LocalOrganisation < ApplicationRecord
    self.table_name = 'organisations'
  end

  class LocalPipeline < ApplicationRecord
    self.table_name = 'pipelines'

    belongs_to :user, class_name: 'LocalUser'
  end

  def up
    add_reference :pipelines, :organisation, foreign_key: true

    LocalPipeline.find_each do |pipeline|
      pipeline.update!(organisation_id: pipeline.user.organisation_id)
    end

    remove_reference :pipelines, :user
    change_column_null :pipelines, :organisation_id, false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
