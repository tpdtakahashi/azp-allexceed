class Admin::Estate::Facilities::IndexOrderController < Admin::BaseController

  before_action :load_facility, only: [ :up, :down ]
#  after_action :ajax_responce, only: [ :up, :down ]
  
  def up
    @facility.up_index_order
    ajax_responce
  end
  
  def down
    @facility.down_index_order
    ajax_responce
  end

  def ajax_responce
    respond_to do |format|
      format.json { render json: {status:"ok",id:@facility.id} }
    end
  end
  
  def load_facility
    @facility = ::Estate::Facility.find(params[:id])
  end
  
  
end