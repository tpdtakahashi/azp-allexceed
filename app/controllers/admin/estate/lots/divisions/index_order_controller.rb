class Admin::Estate::Lots::Divisions::IndexOrderController < Admin::BaseController

  before_action :load_division, only: [ :up, :down ]
#  after_action :ajax_responce, only: [ :up, :down ]
  
  def up
    @division.up_index_order
    ajax_responce
  end
  
  def down
    @division.down_index_order
    ajax_responce
  end

  def ajax_responce
    respond_to do |format|
      format.json { render json: {status:"ok",id:@division.id} }
    end
  end
  
  def load_division
    @division = ::Estate::Land.find(params[:id])
  end
  
  
end