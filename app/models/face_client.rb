require 'net/http'
require 'base64'
class FaceClient
	API_KEY = '19a0cc7311c5bef93f5c845d325ba9dc'
	API_SECRET = 'QK6oigj-DPoUeY_J8tYjU1O7iAzIuwkM'

	def self.detectFace(face_url)
		Net::HTTP.get(URI("https://apius.faceplusplus.com/v2/detection/detect?url=https://powerful-spire-1087.herokuapp.com#{face_url}&api_secret=#{API_SECRET}&api_key=#{API_KEY}&attribute=glass,pose,gender,age,race,smiling"))
	end

	def self.addToFaceSet(face_id)
		Net::HTTP.get(URI("https://apius.faceplusplus.com/v2/faceset/add_face?api_key=#{API_KEY}&api_secret=#{API_SECRET}&face_id=#{face_id}&faceset_name=MissingChildren"))
	end

	def self.searchFaceInFaceSet(face_url)
		Net::HTTP.get(URI("https://apius.faceplusplus.com/v2/train/search?api_secret=#{API_SECRET}&api_key=#{API_KEY}&faceset_name=MissingChildren"))
		response = self.detectFace(face_url)
		face_id = JSON.parse(response)["face"][0]["face_id"]
		Net::HTTP.get(URI("https://apius.faceplusplus.com/v2/recognition/search?api_secret=#{API_SECRET}&api_key=#{API_KEY}&key_face_id=#{face_id}&faceset_name=MissingChildren"))
	end
end
