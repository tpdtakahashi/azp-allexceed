class Admin::Estate::LandsController < Admin::Estate::BaseController

    before_action :load_record, only: %i(show edit update destroy)
    def index
        @lands = ::Estate::Land.singles.all
    end

    def show
    end

    def new
      @record = ::Estate::Land.new
    end

    def create
      @record = ::Estate::Land.new(estate_land_params)
      respond_to do |format|
        if @record.save
          format.json { render json: {status:"ok",id:@record.id} }
        else
          ret_json = {status:"error", errors:[]}
          @record.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.product.#{attr}"}#{mes}\"}"}
          format.json { render json: ret_json, status: :ok  }
        end
      end
    end

    def edit
    end
    
    def update
        respond_to do |format|
            if @record.update_attributes(estate_land_params)
              format.json { render json: {status:"ok",id:@record.id} }
            else
              ret_json = {status:"error", errors:[]}
              @record.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.product.#{attr}"}#{mes}\"}"}
              format.json { render json: ret_json, status: :ok  }
            end
        end
    end

    def destroy
    end


protected

    # 
    def load_record
        @record = ::Estate::Land.find( params[:id] )
    end

    #
    def estate_land_params
        params.require(:estate_land).permit(
          :name, :summary, :category,
          :zip_code, :address_pref, :address_city, :address_area, :address_else,
          :elementaly_school, :junior_high_school, :station, :traffic,
          :chimoku, :kuiki, :youto, :kenpei, :youseki, :douro, :torihikitaiyou,
          :pr_comment, :description, :memo,
          :syoukai_label_1,:syoukai_memo_1,:syoukai_label_2,:syoukai_memo_2,:syoukai_label_3,:syoukai_memo_3,:syoukai_label_4,:syoukai_memo_4,
          :price, :land_area_size
        )
    end
end
