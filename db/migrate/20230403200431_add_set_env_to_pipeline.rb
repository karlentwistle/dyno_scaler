# frozen_string_literal: true

class AddSetEnvToPipeline < ActiveRecord::Migration[7.0]
  def change
    add_column :pipelines, :set_env, :boolean, default: false, null: false
  end
end
