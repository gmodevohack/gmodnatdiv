class PhenotypeController < ApplicationController

  def index
    redirect_to :action => :list
  end

  def list
    @phenotypes = Phenotype.limit.ordered_by_number_of_cvterms
    # find(:all, :limit => 100).order_by_number_of_cvterms
  end

  def new
    @phenotype = Phenotype.new
  end

  def edit
    @phenotype = Phenotype.find(params[:id])
  end

  def create
    @phenotype = Phenotype.new(params[:phenotype])
    if @phenotype.save
      redirect_to :action => :list
    else
      redirect_to :action => :new
    end
  end

  def update 
    if @phenotype = Phenotype.find(params[:phenotype][:phenotype_id])
      @phenotype.update_attributes(params[:phenotype])
    else
      redirect_to :action => :list and return
    end
    redirect_to :action => :show, :id => @phenotype.phenotype_id 
  end

  def destroy
    @phenotype = Phenotype.find(params[:id])
    @phenotype.destroy
    flash[:notice] = "Destroyed!"
    redirect_to :action => :index
  end

  def show
    @phenotype = Phenotype.find(params[:id])
  end
end
