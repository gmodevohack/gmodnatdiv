class LibraryDbxref < ActiveRecord::Base
    belongs_to :library, :class_name => 'Library', :foreign_key => :library_id
    belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
    
end
