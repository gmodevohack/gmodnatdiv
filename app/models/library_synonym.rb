class LibrarySynonym < ActiveRecord::Base
    belongs_to :synonym, :class_name => 'Synonym', :foreign_key => :synonym_id
    belongs_to :library, :class_name => 'Library', :foreign_key => :library_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
