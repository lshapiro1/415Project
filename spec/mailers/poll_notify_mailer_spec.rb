require "rails_helper"

RSpec.describe PollNotifyMailer, type: :mailer do
  describe "notify_email" do

    it "correctly constructs the poll notification email" do
      fakeuser = FactoryBot.create(:admin)
      c = FactoryBot.create(:course)
      q = FactoryBot.build(:multi_choice_question, :qname => "Q1", :qcontent => %w{one two three four}, :course => c)
      c.questions << q
      q.save
      p = q.new_poll(:isopen => true, :round => 1)
      p.save

      mail = PollNotifyMailer.with(user: fakeuser, poll: p).notify_email
      expect(mail.subject).to eq("Poll results: Q1")
      expect(mail.to).to eq(["jsommers@colgate.edu"])
      expect(mail.from).to eq(["icqappjs@gmail.com"])

      expectbody = %Q{Content-Type: text/plain;\r\n charset=UTF-8\r\nContent-Transfer-Encoding: 7bit\r\n\r\none: 0\r\ntwo: 0\r\nthree: 0\r\nfour: 0\r\n\r\n}
      expect(mail.body.parts[0].to_s).to eq(expectbody)
    end
  end
end
