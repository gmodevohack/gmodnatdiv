class VizController < ApplicationController

  protect_from_forgery :except => [:auto_complete_for_stock_name]

  def index
  end

  def plot_bubble
   pieces = params[:id].split(":")
   @term = Cvterm.with_obo_id(pieces[0], pieces[1]).first
   @associations = ActiveSupport::JSON.encode(experiment_associations_data(@term))
    render :action => 'plots/plot_bubble'
  end

  def plot_multivar
    pieces = params[:id].split(":")
    @term = Cvterm.with_obo_id(pieces[0], pieces[1]).first
    @associations = ActiveSupport::JSON.encode(experiment_associations_data(@term))

#    render :action => 'plots/plot_bubble'
  end 

  def form_test
  end
  
  private
  
  def experiment_associations_data(term)
    max_depth = 3
    depth = 0
    is_a = Cvterm.with_obo_id("OBO_REL", "is_a").first
    return {term.name => experiment_associations(term, depth, max_depth, is_a)}
  end
  
  def experiment_associations(term, depth, max_depth, relation)
    map = {}
    children_rels = term.children.by_relation(relation)
    if ((depth < max_depth) && (children_rels.size > 0))
      children_rels.each do |child_rel|
        child = child_rel.child
        if (child.children.size == 0)
          map[child.name] = (experiments_for_term(child, relation) + 1) * 4000
        else 
          map[child.name] = experiment_associations(child, depth + 1, max_depth, relation)
        end
      end
    else
      return (experiments_for_term(term, relation) + 1) * 4000
    end
    return map
  end
  
  def experiments_for_term(term, relation)
    this_term_count = term.observables.count
    term.children.by_relation(relation).each do |child_rel|
      this_term_count += experiments_for_term(child_rel.child, relation)
    end
    this_term_count
  end
  

  def auto_complete_for_stock_name
    @stocks =  Stock.find(:all, :conditions => ['name LIKE ?', "%#{params[:stock][:name]}%"])
    @tag_id_str = params[:tag_id]
      render :inline => "<%= auto_complete_result_with_ids(@stocks,
      'format_obj_for_auto_complete', @tag_id_str) %>" 
  end


end
