class Admin::Estate::HousesController < Admin::Estate::BaseController

    before_action :load_house, only: %i(show edit update destroy)
    def index
        @houses = ::Estate::House.all
    end

    def show
    end

    def new
      @house = ::Estate::House.new
      @house.builded_on = Date.today
    end

    def create
      @house = ::Estate::House.new(estate_house_params)
      respond_to do |format|
        if @house.save
          format.json { render json: {status:"ok",id:@house.id} }
        else
          ret_json = {status:"error", errors:[]}
          @house.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.product.#{attr}"}#{mes}\"}"}
          format.json { render json: ret_json, status: :ok  }
        end
      end
    end

    def edit
    end
    
    def update
        respond_to do |format|
            if @house.update_attributes(estate_house_params)
              format.json { render json: {status:"ok",id:@house.id} }
            else
              ret_json = {status:"error", errors:[]}
              @house.errors.each { |attr,mes| ret_json[:errors] << "{\"attribute\": \"#{attr}\", \"error\": \"#{I18n.t "activerecord.attributes.product.#{attr}"}#{mes}\"}"}
              format.json { render json: ret_json, status: :ok  }
            end
        end
    end

    def destroy
    end


protected

    # 
    def load_house
        @house = ::Estate::House.find( params[:id] )
    end

    #
    def estate_house_params
        params.require(:estate_house).permit(
            :name, :summary, :category,
            :zip_code, :address_pref, :address_city, :address_area, :address_else,
            :elementaly_school, :junior_high_school, :station, :traffic,
            :chimoku, :kuiki, :youto, :kenpei, :youseki, :douro, :torihikitaiyou,
            :pr_comment, :description, :memo,
            :syoukai_label_1,:syoukai_memo_1,:syoukai_label_2,:syoukai_memo_2,:syoukai_label_3,:syoukai_memo_3,:syoukai_label_4,:syoukai_memo_4,
            :price, :land_area_size, :house_area_size, :madori,
            :builded_on_year, :builded_on_month,
            :parking_number, :parking_info,
            :setsubi, :denki, :gas, :suido, :gesui
        )
    end
end
