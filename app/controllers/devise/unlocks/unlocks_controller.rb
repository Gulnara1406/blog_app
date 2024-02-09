class Devise::UnlocksController < DeviseController
    # GET /resource/unlock/new
  def new
    build_resource({})
    render_with_scope :new
  end
  
    # POST /resource/unlock
  def create
    self.resource = resource_class.send_unlock_instructions(resource_params)
  
    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_unlock_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
  
    # GET /resource/unlock?unlock_token=abcdef
  def show
    self.resource = resource_class.find_by_unlock_token(params[:unlock_token])
  
    if resource.nil? || !resource.locked?
      render_with_scope :invalid_unlock_token
    else
      render_with_scope :edit
    end
  end
  
    # PUT /resource/unlock
  def update
    self.resource = resource_class.unlock_access_by_token(resource_params)
  
    if resource.errors.empty?
      set_flash_message :notice, :unlocked if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_unlocking_path_for(resource)
    else
      respond_with resource
    end
  end
  
  protected
  
  def after_unlocking_path_for(resource)
    Devise.mappings[resource_name].root_path
  end
  
    
  def after_sending_unlock_instructions_path_for(resource_name)
    Devise.mappings[resource_name].root_path
  end
end
  