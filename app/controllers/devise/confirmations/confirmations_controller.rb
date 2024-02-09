class Devise::ConfirmationsController < DeviseController
    # GET /resource/confirmation/new
  def new
    self.resource = resource_class.new
  end
  
    # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
  
    if successfully_sent?(resource)
      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
  
    # GET /resource/confirmation?confirmation_token=abcdef
def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
  
    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_with_navigational(resource) {
  