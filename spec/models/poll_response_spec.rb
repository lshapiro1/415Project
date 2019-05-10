require 'rails_helper'

RSpec.describe PollResponse, type: :model do
  describe "free poll response" do
    r = PollResponse.new(:type => "FreeResponsePollResponse", :response => "stuff")    
    c = FactoryBot.create(:course)
    q = Question.new(:type => "FreeResponseQuestion", :qname => "free response question")
    c.questions << q
    q.save
  end

end
