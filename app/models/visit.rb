# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visited_id :integer          not null
#  visitor_id :integer          not null
#
# Indexes
#
#  index_visits_on_visited_id  (visited_id)
#  index_visits_on_visitor_id  (visitor_id)
#
# Foreign Keys
#
#  visited_id  (visited_id => users.id)
#  visitor_id  (visitor_id => users.id)
#
class Visit < ApplicationRecord
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
end
