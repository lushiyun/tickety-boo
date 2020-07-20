class CreateMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :meetings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :ticket, null: false, foreign_key: true
      t.references :requester, references: :users, foreign_key: { to_table: :users }
      t.references :requestee, references: :users, foreign_key: { to_table: :users}
      t.timestamps
    end
  end
end