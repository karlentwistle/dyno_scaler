# frozen_string_literal: true

class CreatePipelines < ActiveRecord::Migration[7.0]
  def change
    create_table :pipelines do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uuid, null: false
      t.string :api_key, null: false
      t.integer :base_size_id, null: false
      t.integer :boost_size_id, null: false

      t.timestamps
    end
  end
end
