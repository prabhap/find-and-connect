class AddDetailsToChildren < ActiveRecord::Migration
  def change
    add_column :children, :name, :string
    add_column :children, :identification_mark, :text
    add_column :children, :age, :integer
    add_column :children, :contact_no, :string
  end
end
