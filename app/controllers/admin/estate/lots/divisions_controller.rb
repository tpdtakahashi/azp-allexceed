class Admin::Estate::Lots::DivisionsController < Admin::Estate::BaseController

    before_action :load_lot
    before_action :load_record, only: %i(show edit update destroy)
    def index
        @lands = @lot.divisions
    end

    def show
    end

    def new
      @record = @lot.divisions.new
    end

    def create
      @record = @lot.divisions.new(estate_land_params)
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
      @record.destroy
      respond_to do |format|
          format.json { render json: {status:"ok",id:@record.id} }
      end
    end


protected

    # 
    def load_lot
        @lot = ::Estate::Land.find( params[:lot_id] )
    end
    # 
    def load_record
      @record = ::Estate::Land.find( params[:id] )
  end

    #
    def estate_land_params
        params.require(:estate_land).permit(
          :name, :summary, :category,
          :pr_comment, :description, :memo,
          :price, :land_area_size
        )
    end
end
