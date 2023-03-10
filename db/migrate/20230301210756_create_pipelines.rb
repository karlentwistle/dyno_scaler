# frozen_string_literal: true

class CreatePipelines < ActiveRecord::Migration[7.0]
  def change
    create_table :pipelines do |t|
      t.string :uuid, null: false
      t.string :api_key, null: false

      t.timestamps
    end
  end
end
