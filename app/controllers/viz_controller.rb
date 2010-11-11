class VizController < ApplicationController

  def index
  end

  def plot_bubble
    render :action => 'plots/plot_bubble'
  end

  def plot_multivar
    render :action => 'plots/plot_bubble'
  end 

end
