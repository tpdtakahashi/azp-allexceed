class Admin::ConfigController < Admin::BaseController
  def index
    @configs = Tpd::AppConfig.where(system_lock: 0)
  end

  def update
    config = Tpd::AppConfig.where(code: params[:code]).first
    
    
    respond_to do |format|
      if config.update_attributes(value_string: params[:value])
        format.json { render json: {status:"ok"} }
      else
        ret_json = {status:"error", errors:[]}
        config.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.customer.#{attr}"}#{mes}\"}"}
        format.json { render json: ret_json, status: :ok  }
      end
    end
  end
end
