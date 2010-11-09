class Phendesc < ActiveRecord::Base
    belongs_to :genotype, :class_name => 'Genotype', :foreign_key => :genotype_id
    belongs_to :environment, :class_name => 'Environment', :foreign_key => :environment_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
