class LibraryFeature < ActiveRecord::Base
    belongs_to :library, :class_name => 'Library', :foreign_key => :library_id
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    
end
