class ApplicationRecord < ActiveRecord::Base
  require 'csv'
  require 'active_record'
  require 'activerecord-import'
  self.abstract_class = true
end
