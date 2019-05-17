require 'rails_helper'

RSpec.describe "CreateAndActivates", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "XHR for poll response" do
    it "should be successful with appropriate info in the POST" do
      s = FactoryBot.create(:student)
      sign_in s
      c = FactoryBot.create(:course)
      c.students << s
      q = c.questions.create(:qname => "question", :type => "NumericQuestion")
      p = q.new_poll(:round => 1, :isopen => true)
      p.save!
      headers = {
        "ACCEPT" => "application/json",
        "HTTP_ACCEPT" => "application/json",
        'X-Requested-With' => 'XMLHttpRequest',
      }
      post course_question_poll_poll_responses_path(c, q, p), :params => {:course_id => c.id, :question_id => q.id, :poll_id => p.id, :response => "1.0"}, :headers => headers
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json")
      expect(PollResponse.where(:user => s, :poll => p).first.response).to eq(1.0)
    end
  end
end
