class PubDbxref < ActiveRecord::Base
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
