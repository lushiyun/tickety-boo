class AddResolvedToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :resolved, :boolean, default: false
    add_column :tickets, :public, :boolean, default: false
  end
end
