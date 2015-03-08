
class ChildrenController < ApplicationController
  def register
    @child = Child.new
  end

  def index
  end

  def show
    @child = Child.find(params[:id])
  end

  def create
    info = params[:child]
    @child = Child.new(avatar: info["avatar"], age: info["age"],
                       identification_mark: info["identification_mark"], contact_no: info["contact_no"], name: info["name"])
    @child.save!

    logger.debug "************ Dummy call Started"
    # A dummy call to cache the image response.
    Net::HTTP.get(URI("https://powerful-spire-1087.herokuapp.com/data/#{@child.avatar.identifier}"))
    logger.debug "************ Dummy call Done"

    response = FaceClient.detectFace("#{@child.avatar.identifier}")
    logger.debug "************ Response is #{response}"
    raise response
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
     @child = Child.new
  end

  def match_child
    info = params[:child]
    @child = Child.new(avatar: info["avatar"])
    @child.save!
    response = FaceClient.detectFace("#{@child.avatar.identifier}")
    raise response
    face_id = JSON.parse(response)["face"][0]["face_id"]
  	response = FaceClient.searchFaceInFaceSet(face_id)
    matches = JSON.parse(response)["candidate"]
    if(!matches.empty?)
       found_children = Child.where(face_id: matches.collect{|candidate| candidate["face_id"]})
       redirect_to "/children/show/#{found_children.last.id}"
    else
      render text: "child not found in our system"
    end
  end
end
