
class ChildrenController < ApplicationController
  def index
  end

  def register
    @child = Child.new
  end

  def report_anonymous_child
    @child = Child.new
  end

  def show
    @child = Child.find(params[:id])
  end

  def create
    info = params[:child]
    @child = Child.new(avatar: info["avatar"], age: info["age"],
                       identification_mark: info["identification_mark"], contact_no: info["contact_no"],
                       name: info["name"], reported_by: info["reported_by"])
    @child.save!
    response = FaceClient.detectFace("#{@child.avatar.file.filename}")
    face_id = JSON.parse(response)["face"][0]["face_id"]
    FaceClient.addToFaceSet(face_id)
    @child.update_attributes(face_id: face_id)
    flash[:notice] = "You have successfully registered. Your registration id is #{@child.id}"
    redirect_to controller: "children", action: "search", id: @child.id
  end

  def permit_params
    params.require(:child).permit(:name, :age, :contact_no, :identification_mark, :avatar)
  end

  def search
     #@child = Child.new(reported_by: params["reported_by"])
    #@child = Child.find(params["id"])
    @child = Child.new(id: params["id"])
  end

  def is_parent(reported_by)
    reported_by == "parent"
  end

  def match_child
    info = params[:child]
    @child = Child.find(info["id"])
    response = FaceClient.detectFace("#{@child.avatar.file.filename}")
    face_id = JSON.parse(response)["face"][0]["face_id"]

  	response = FaceClient.searchFaceInFaceSet(face_id)
    matches = JSON.parse(response)["candidate"]
    @matches = matches.select {|candidate| candidate["similarity"] > 70} if(!matches.empty?)

    if !@matches.empty?
       logger.info "************* Match Full response #{response}"
       logger.info "************* Match Candidate response #{matches}"
       @found_children = Child.where(face_id: @matches.collect{|candidate| candidate["face_id"]},
                                       reported_by: is_parent(@child.reported_by) ? "anonymous" : "parent")
    end
    if(@matches.empty? || @found_children.empty?)
      render text: "child not found in our system"
    end
  end
end
