class Admin::Estate::Images::IndexOrderController < Admin::BaseController

  before_action :load_picture, only: [ :up, :down ]
#  after_action :ajax_responce, only: [ :up, :down ]
  
  def up
    @picture.up_index_order
    ajax_responce
  end
  
  def down
    @picture.down_index_order
    ajax_responce
  end

  def ajax_responce
    respond_to do |format|
      format.json { render json: {status:"ok",id:@picture.id} }
    end
  end
  
  def load_picture
    @picture = ::Estate::Picture.find(params[:id])
  end
  
  
end