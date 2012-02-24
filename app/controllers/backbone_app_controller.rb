class BackboneAppController < ApplicationController
  layout 'backboneApp'
  respond_to :html, :json
	def show
    
  end

  def user_info
    respond_with({
        'uuid' => UUIDTools::UUID.random_create.to_s,
        'socketURL' => self.get_socket_url
    })
  end

  protected
  def get_socket_url
    Rails.env.production? ? "http://ws.example.com" : "http://0.0.0.0:5001"
  end
end
