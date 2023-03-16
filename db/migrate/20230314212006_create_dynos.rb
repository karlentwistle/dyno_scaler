# frozen_string_literal: true

class CreateDynos < ActiveRecord::Migration[7.0]
  def change
    create_table :dynos do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.string :log_token, null: false
      t.string :app_id, null: false
      t.datetime :last_active_at

      t.timestamps
    end

    add_index :dynos, :log_token, unique: true
    add_index :dynos, :app_id, unique: true
  end
end
