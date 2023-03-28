# frozen_string_literal: true

class CreateReviewApps < ActiveRecord::Migration[7.0]
  def change
    create_table :review_apps do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.string :log_token, null: false
      t.string :app_id, null: false
      t.datetime :last_active_at, null: false
      t.integer :base_size_id, null: false
      t.integer :boost_size_id, null: false
      t.integer :current_size_id

      t.timestamps
    end

    add_index :review_apps, :log_token, unique: true
    add_index :review_apps, :app_id, unique: true
  end
end
