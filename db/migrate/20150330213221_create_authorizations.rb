class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user, index: true, foreign_key: true
      t.string :auth_code
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_in
      t.string :carrier

      t.timestamps null: false
    end
  end
end
