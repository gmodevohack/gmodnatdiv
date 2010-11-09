class Expression < ActiveRecord::Base
    has_many :expression_cvterms , :foreign_key => :expression_id
    has_many :cvterms 
    has_many :expression_images , :foreign_key => :expression_id
    has_many :eimages 
    has_many :expression_pubs , :foreign_key => :expression_id
    has_many :pubs 
    has_many :expressionprops , :foreign_key => :expression_id
    has_many :feature_expressions , :foreign_key => :expression_id
    has_many :features 
    has_many :pubs 

  validates_presence_of( :uniquename )

  has_many :wwwuser_expressions

  set_table_name "expression"
  set_primary_key "expression_id"

end
