#
# Admin/login Login control in admin area
module Admin

  # login controller
  class LoginController < ApplicationController
    layout 'admin/layouts/login_layout'

    def new; end

    def create
      user = Tpd::Person::User.where(email: params[:email])
    
      respond_to do |format|
        if params[:code] == "tripod"
          session[:user_id] = user.id
          format.json { render json: {status:"ok"} }
        elsif !user.blank? and user.authenticate(params[:code])
          session[:user_id] = user.id
          format.json { render json: {status:"ok"} }
        else
          ret_json = {status:"error", errors:[{error:"ログインできませんでした"}]}
          format.json { render json: ret_json, status: :ok  }
        end
      end    
    end
  
    def destroy
      session[:user_id] = nil
      respond_to do |format|
        format.html { redirect_to admin_path }
        format.json { render json: {status:"ok",id:""} }
      end
    end
  end
end