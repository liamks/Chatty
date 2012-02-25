class BackboneAppController < ApplicationController
  layout 'backboneApp'
  respond_to :html, :json
	def show
    response.headers['Cache-Control'] = 'public, max-age=25300' if Rails.env.production?
  end

  def user_info
    respond_with({
        'id' => UUIDTools::UUID.random_create.to_s,
        'socketURL' => self.get_socket_url
    })
  end

  protected
  def get_socket_url
    Rails.env.production? ? "http://chatty-server.herokuapp.com/" : "http://0.0.0.0:5001"
  end
end
