class EnvironmentCvterm < ActiveRecord::Base
    belongs_to :environment, :class_name => 'Environment', :foreign_key => :environment_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    
end
