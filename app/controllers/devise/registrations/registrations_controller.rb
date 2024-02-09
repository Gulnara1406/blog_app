class Devise::RegistrationsController < DeviseController
    # GET /resource/sign_up
  def new
    build_resource({})
    respond_with resource
  end
  
    # POST /resource
  def create
    build_resource(sign_up_params)
  
    resource.save
    yield resource if block_given?
  
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_
  