class AddFaceIdToChild < ActiveRecord::Migration
  def change
  	add_column :children, :face_id, :string
  end
end
