class CreateAuthorizationsE911Contexts < ActiveRecord::Migration
  def change
    create_table :authorizations_e911_contexts do |t|
      t.references :authorization, index: true, foreign_key: true
      t.references :e911_context, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
