class Devise::SessionsController < DeviseController
    prepend_before_action :require_no_authentication, only: [:new, :create]
    prepend_before_action :allow_params_authentication!, only: :create
    prepend_before_action(only: [:create, :destroy]) { request.env["devise.skip_timeout"] = true }
  
    # GET /resource/sign_in
    def new
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords resource
      respond_with(resource, serialize_options(resource))
    end
  
    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  
    # DELETE /resource/sign_out
    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
      yield if block_given?
      respond_to_on_destroy
    end
  
    protected
  
    def sign_in(resource_or_scope, resource = nil)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      resource ||= resource_or_scope
      sign_in_and_redirect(scope, resource)
    end
  
    def after_sign_in_path_for(resource)
      stored_location_for(resource) || Devise.mappings[scope].root_path
    end
  
    def respond_to_on_destroy
      if is_flashing_format?
        flash[:alert] = I18n.t("devise.sessions.signed_out")
        render "new"
      else
        head :no_content
      end
    end
  
    def auth_options
      { scope: resource_name, recall: "#{controller_path}#new" }
    end
  end
  