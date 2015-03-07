class ChildrenController < ApplicationController
  def register
    @child = Child.new
  end

  def index
  end

  def create
    info = params[:child]
    @child = Child.new(avatar: info["avatar"], age: info["age"],
                       identification_mark: info["identification_mark"], contact_no: info["contact_no"], name: info["name"])
    @child.save!
    flash[:notice] = "You have successfully registered. Your registration id is #{@child.id}"
    redirect_to controller: "children", action: "search", id: @child.id
  end

  def permit_params
    params.require(:child).permit(:name, :age, :contact_no, :identification_mark, :avatar)
  end

  def search
    @id = params[:id]
  end
end
