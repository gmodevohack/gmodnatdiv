class Entry < ActiveRecord::Base
def self.find_all_stocks
 Stock.find(:all)
end
end
