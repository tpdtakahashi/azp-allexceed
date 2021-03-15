class Admin::Estate::FacilitiesController < Admin::Estate::BaseController

    before_filter :load_estate
    before_filter :load_facility, only: %i(edit update destroy)

    def index
        @facilities = @estate.facilities.where(summary: nil)
    end


    def new
        @facility = @estate.facilities.new
    end

    def create
        @facility = @estate.facilities.new( facility_params )

        respond_to do |format|
            if @facility.save
                format.json { render json: {status:"ok",id:@facility.id} }
            else
                ret_json = {status:"error", errors: []}
                @facility.errors.each { |attr,mes| ret_json[:errors] << {attribute: attr.to_s, error: I18n.t("activerecord.attributes.picture.#{attr}") + mes}}
                format.json { render json: ret_json, status: :ok  }
            end
        end
    end

    def edit
    end

    def update
    end

    def destroy
        @facility.destroy
        respond_to do |format|
            format.json { render json: {status:"ok",id:@facility.id} }
        end
    end


    def facility_params
        attr = params.require(:facility).permit(
            :name, :category, :summary, :distance,
            :zip_code, :address_pref, :address_city, :address_area, :address_else,
            )
    end

    def load_estate
        @estate = ::Estate::Common.find(params[:common_id])
    end

    def load_facility
        @facility = @estate.facilities.find(params[:id])
    end

end
