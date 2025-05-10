Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "navigator_bar#index"
  root "application#show_content"
  get "contact_us", to: "generals#index"
  get "backend-admin", to: "navigator_bar#index"
  
  get ":menu", to: "application#show_content"
  get ":menu/sub", to: "application#show_sub_content"
  

  scope "backend-admin" do
    
    get "navigator", to: "navigator_bar#index"
    post "navigator", to: "navigator_bar#create"
    delete "navigator", to: "navigator_bar#destroy"
    get "navigator_datatable", to: "navigator_bar#show_datatable"

    get "get_navigator_data", to: "navigator_bar#get_data"

    get "public_content", to: "application#public_content"
    post "upload_banner", to: "content#upload_banner"
    delete "upload_banner", to: "content#delete_banner" 

    get "content", to: "content#add_content"
    get "content/:menu", to: "content#add_content"
    post "content", to: "content#create_content"
    delete "content", to: "content#delete_content"
    get "get_content", to: "content#get_content"
    get "get_format_content", to: "content#change_format"

    delete "cover", to: "content#delete_cover"
    get "get_cover", to: "content#get_cover"
    # get "sub_content", to: "application#sub_content"
    get "content/:menu/:cover_id", to: "content#sub_content"
    patch "content/get_embed", to: "content#get_embed"

    get "additional", to: "additional_content#index"
    get "additional/:menu", to: "additional_content#index"
    delete "additional", to: "additional_content#delete_additional_content"
    post "update_additional", to: "additional_content#update_additional"
    get "get_additional_data", to: "additional_content#get_additional_data"

    get "additional_datatable", to: "additional_content#show_table"
    
    resource :general
    resource :user

    get "activity_log", to: "activity_log#index"
    get "activity_log/datatable", to: "activity_log#datatable"

    get "login" , to: "login#index"
    post "login/authenicate", to: "login#authenicate"
    get "login/logout", to: "login#logout"
    get "login/forgot_password", to: "login#forgot_password"
    post "login/reset_password", to: "login#reset_password"
    get "login/reset", to: "login#new_password"
    post "login/change_password", to: "login#change_password"
  end
end
