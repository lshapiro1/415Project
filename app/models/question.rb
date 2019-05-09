class Question < ApplicationRecord
  belongs_to :course
  has_many :polls
  validates :question, presence: true
  enum content_type: %i(html markdown plain)
end

class MultiChoiceQuestion < Question
  has_many :multi_choice_options
end

class FreeResponseQuestion < Question
end

class NumericQuestion < Question
end
