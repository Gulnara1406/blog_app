class Devise::PasswordsController < DeviseController
    # GET /resource/password/new
  def new
    build_resource({})
    render_with_scope :new
  end
  
    # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)    
    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
  
    # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.find_by_reset_password_token(params[:reset_password_token])
  
    if resource.nil?
      render_with_scope :invalid_reset_password_token
    else
      render_with_scope :edit
    end
  end
  
    # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
  
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      set_flash_message! :notice, :updated_not_active if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end
  
  protected
  
  def after_resetting_password_path_for(resource)
    Devise.mappings[resource_name].root_path
  end
  
  def after_sending_reset_password_instructions_path_for(resource_name)
    Devise.mappings[resource_name].root_path
  end
end
  