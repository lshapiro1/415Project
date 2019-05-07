class Question < ApplicationRecord
  belongs_to :course
  validates :question, presence: true
  enum content_type: %i(html markdown plain)
end

class MultiChoiceQuestion < Question
end

class FreeResponseQuestion < Question
end

class NumericQuestion < Question
end
