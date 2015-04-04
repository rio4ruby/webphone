class CreateRTCSessions < ActiveRecord::Migration
  def change
    create_table :rtc_sessions do |t|
      t.references :user, index: true, foreign_key: true
      t.string :sessionId
      t.datetime :started_at

      t.timestamps null: false
    end
  end
end
