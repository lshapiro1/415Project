require 'rails_helper'

RSpec.describe Poll, type: :model do
  describe "multi choice poll options" do
    it "should return the question options with Poll#options" do
      c = Course.create(:name => "test", :daytime => "TR 9:55-10:10")
      opts= %w{opt1 opt2 opt3}
      q = MultiChoiceQuestion.create(:qname => "question", :course=>c, :qcontent => opts)
      q.save
      poll = q.polls.create(:type=>"MultiChoicePoll")
      expect(poll.options).to eq(opts)
    end
  end
end
