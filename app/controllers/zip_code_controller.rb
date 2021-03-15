class ZipCodeController < ApplicationController

  def show
    zipcode = params[:zipcode].to_s.tr("\-ー―－","").tr("０-９","0-9")
    @zipcode = Tpd::Address::Zip.where(:code => zipcode)

    respond_to do |format|
      format.json { render json: @zipcode }
    end
  end
end