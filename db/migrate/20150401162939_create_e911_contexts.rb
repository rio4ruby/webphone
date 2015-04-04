class CreateE911Contexts < ActiveRecord::Migration
  def change
    create_table :e911_contexts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :e911id
      t.string :name
      t.string :houseNumber
      t.string :houseNumExt
      t.string :streetDir
      t.string :streetDirSuffix
      t.string :street
      t.string :streetNameSuffix
      t.string :unit
      t.string :city
      t.string :state
      t.string :zip
      t.string :addressAdditional
      t.string :comments
      t.boolean :isAddressConfirmed

      t.timestamps null: false
    end
  end
end
