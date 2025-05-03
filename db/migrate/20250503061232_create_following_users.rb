# frozen_string_literal: true

class CreateFollowingUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :following_users, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :following_user, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :following_users, %i[user_id following_user_id], unique: true
  end
end
