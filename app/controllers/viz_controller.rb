class VizController < ApplicationController

  protect_from_forgery :except => [:auto_complete_for_stock_name]

  def index
  end

  def plot_bubble
    render :action => 'plots/plot_bubble'
  end

  def plot_multivar
    render :action => 'plots/plot_bubble'
  end 

  def form_test
  end

  def auto_complete_for_stock_name
    @stocks =  Stock.find(:all, :conditions => ['name LIKE ?', "%#{params[:stock][:name]}%"])
    @tag_id_str = params[:tag_id]
      render :inline => "<%= auto_complete_result_with_ids(@stocks,
      'format_obj_for_auto_complete', @tag_id_str) %>" 
  end


end
