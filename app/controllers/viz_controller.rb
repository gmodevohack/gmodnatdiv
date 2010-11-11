class VizController < ApplicationController

  def index
   
  end

  def fancyname(stock)
    "#{stock.organism.genus} #{stock.organism.species} (#{stock.uniquename})"
  end

  def multivar_scatter

    @data = {     }
 
    # species -  Stock.name
    # traits  -  Phenotype.unique_name 
    # flowers -   
    

    @traits = Phenotype.find(:all, :limit => 20)

    @stocks = ActiveSupport::JSON.encode(Stock.find(:all).collect {|stock| fancyname(stock)})
    #@traits = ActiveSupport::JSON.encode(Phenotype.find(:all).collect {|phenotype| phenotype.uniquename})
    @observations = ActiveSupport::JSON.encode(NdExperimentPhenotype.find(:all)[0,50].collect {|exp_phenotype|
      map = {"stock" => fancyname(exp_phenotype.nd_experiment.nd_experiment_stocks.collect{|ndexp| ndexp.stock}[0]) }
      map[exp_phenotype.phenotype.uniquename] = exp_phenotype.nd_experiment_phenotypeprops.collect{|prop| prop.value}[0]
      map
    })


  end

  def form_test

  end

  
  def configure_viz
    debugger
    foo = 1
  end


end
