class AddReportedByToChildren < ActiveRecord::Migration
  def change
    add_column :children, :reported_by, :string
  end
end
