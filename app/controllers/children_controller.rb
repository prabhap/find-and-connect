class ChildrenController < ApplicationController
  def index
    @child = Child.new
  end

  def create
    @child = Child.new(avatar: params["child"]["avatar"])
    @child.save!
    render text: "saved"
  end
end
