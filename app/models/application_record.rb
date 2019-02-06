class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sort_by_session, -> (session) { order(session['sort'].to_sym => session['index'].to_sym) unless (session.nil? or session['sort'].nil? or session['index'].nil?) }
end
