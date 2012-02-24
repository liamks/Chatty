BackboneOnRails::Application.routes.draw do

  match "/chatty" => 'backboneApp#show'
  match "/get_user_info" => 'backboneApp#user_info'
  # root :to => 'welcome#index'

end
