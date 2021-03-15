class Admin::Estate::ImagesController < Admin::Estate::BaseController

    before_filter :load_estate
    before_filter :load_image, only: %i(edit update destroy)

    def index
        @images = @estate.images.where(summary: nil)
    end


    def new
        @image = @estate.images.new
    end

    def create
        @image = @estate.images.new( image_params )
        logger.debug "@image.file_type: #{@image.file_type}"
        logger.debug "@image.file_name: #{@image.file_name}"

        respond_to do |format|
            if @image.save
                format.json { render json: {status:"ok",id:@image.id} }
            else
                ret_json = {status:"error", errors: []}
                @image.errors.each { |attr,mes| ret_json[:errors] << {attribute: attr.to_s, error: I18n.t("activerecord.attributes.picture.#{attr}") + mes}}
                format.json { render json: ret_json, status: :ok  }
            end
        end
    end

    def edit
    end

    def update
    end

    def destroy
        @image.destroy
        respond_to do |format|
            format.json { render json: {status:"ok",id:@image.id} }
        end
    end


    def image_params
        attr = params.require(:image).permit(
            :file_name, :title, :summary, :comment, :upfile,
            :published
            )
    end

    def load_estate
        @estate = ::Estate::Common.find(params[:common_id])
    end

    def load_image
        @image = @estate.images.find(params[:id])
    end

end
