class Admin::OwnerController < Admin::BaseController
  def show
  end

  def edit
    @owner = ShopOwner.load
  end

  def update
    attr = params.require(:shop_owner).permit(
      :first_name, :first_name_kana, :name, :kana,
      :telephone, :fax,
      :zip_code,
      :address_pref, :address_city, :address_area, :address_else
      )
    @owner = ShopOwner.load

    respond_to do |format|
      if @owner.update_attributes(attr)
        format.json { render json: {status:"ok",id:@owner.id} }
      else
        ret_json = {status:"error", errors:[]}
        @owner.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.customer.#{attr}"}#{mes}\"}"}
        format.json { render json: ret_json, status: :ok  }
      end
    end  
  end
  
  def password
  end
  def password_update
    @owner = ShopOwner.load

    respond_to do |format|
      if @owner.update_attributes(attr)
        format.json { render json: {status:"ok",id:@owner.id} }
      else
        ret_json = {status:"error", errors:[]}
        @owner.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.customer.#{attr}"}#{mes}\"}"}
        format.json { render json: ret_json, status: :ok  }
      end
    end  
  end
  
end
