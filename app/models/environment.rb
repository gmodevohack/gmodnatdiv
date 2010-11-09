class Environment < ActiveRecord::Base
    has_many :environment_cvterms , :foreign_key => :environment_id
    has_many :cvterms 
    has_many :phendescs , :foreign_key => :environment_id
    has_many :genotypes 
    has_many :pubs 
    has_many :phenstatements , :foreign_key => :environment_id
    has_many :genotypes 
    has_many :pubs 
    has_many :phenotypes 
    
end
