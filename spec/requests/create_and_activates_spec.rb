require 'rails_helper'

RSpec.describe "CreateAndActivates", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "XHR requests" do
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

    it "should get poll responses over xhr" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)
      q = c.questions.create(:qname => "question", :type => "NumericQuestion")
      p = q.new_poll(:round => 1, :isopen => true)
      p.save!
      headers = {
        "ACCEPT" => "application/json",
        "HTTP_ACCEPT" => "application/json",
        'X-Requested-With' => 'XMLHttpRequest',
      }
      get course_question_poll_path(c, q, p), :headers => headers
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json")
    end

    it "should get poll status for open poll over xhr" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)
      q = c.questions.create(:qname => "question", :type => "NumericQuestion")
      p = q.new_poll(:round => 1, :isopen => true)
      p.save!
      headers = {
        "ACCEPT" => "application/json",
        "HTTP_ACCEPT" => "application/json",
        'X-Requested-With' => 'XMLHttpRequest',
      }
      get poll_status_path(c, q, p), :headers => headers
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json")
      body = eval(response.body)
      expect(body[:status]).to eq('open')
    end

    it "should get poll status for closed poll over xhr" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)
      q = c.questions.create(:qname => "question", :type => "NumericQuestion")
      p = q.new_poll(:round => 1, :isopen => false)
      p.save!
      headers = {
        "ACCEPT" => "application/json",
        "HTTP_ACCEPT" => "application/json",
        'X-Requested-With' => 'XMLHttpRequest',
      }
      get poll_status_path(c, q, p), :headers => headers
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json")
      body = eval(response.body)
      expect(body[:status]).to eq('closed')
    end

    it "should get poll status for newly activated poll over xhr" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)
      q = c.questions.create(:qname => "question", :type => "NumericQuestion")
      p = q.new_poll(:round => 1, :isopen => false)
      p.save!
      p2 = q.new_poll(:round => 2, :isopen => true)
      p2.save!
      headers = {
        "ACCEPT" => "application/json",
        "HTTP_ACCEPT" => "application/json",
        'X-Requested-With' => 'XMLHttpRequest',
      }
      get poll_status_path(c, q, p), :headers => headers
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json")
      body = eval(response.body)
      expect(body[:status]).to eq('refresh')
    end

    it "should get redirect for non-xhr requests" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)
      q = c.questions.create(:qname => "question", :type => "NumericQuestion")
      p = q.new_poll(:round => 1, :isopen => false)
      p.save!
      get poll_status_path(c, q, p)
      expect(response).to have_http_status(:redirect)
    end
  end
end
