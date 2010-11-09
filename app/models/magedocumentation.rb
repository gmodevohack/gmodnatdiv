class Magedocumentation < ActiveRecord::Base
    belongs_to :mageml, :class_name => 'Mageml', :foreign_key => :mageml_id
    belongs_to :tableinfo, :class_name => 'Tableinfo', :foreign_key => :tableinfo_id
    
end
