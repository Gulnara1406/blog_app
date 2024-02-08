class RegistrationsController < Devise::RegistrationsController

  before_action :edit, only: [:update]
  
  def new
    session[:current_time] = Time.now
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  
    if @user.save
      redirect_to root_path, notice: 'Вы успешно зарегистрировались!'
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'Данные пользователя обновлены'
    else
      flash.now[:alert] = 'При попытке сохранить пользователя возникли ошибки'
  
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  
    session.delete(:user_id)
  
    redirect_to root_path, notice: 'Пользователь удален'
  end
  
  private
  
  def user_params
    params.require(:user).permit(
    :name, :nickname, :email, :password, :password_confirmation)
  end
end
  