module PpwmMatcher
  describe UserMailer do
    let(:mail_client) { double("Pony", mail: true) }  # Double Pony? Hehe.
    let(:mailer)    { UserMailer.new(mail_client) }

    context "when given no users" do
      it "expects no mail to be sent" do
        mail_client.should_not_receive(:mail)
        mailer.users_assigned([])
      end
    end

    context "when given a single user" do
      it "expects no mail to be sent" do
        mail_client.should_not_receive(:mail)
        mailer.users_assigned([ double("User") ])
      end
    end

    context "when given two users" do
      let(:user1) { double("User", email: 'tim@example.com', github_login: 'timmy') }
      let(:user2) { double("User", email: 'bob@example.com', github_login: 'bobby') }

      it "expects mail to be sent" do
        mail_client.should_receive(:mail) do |opts|
          opts[:to].should == user1.email
          opts[:subject].should == "You've been paired up with bobby!"
          opts[:body].should include("You can email him at bob@example.com")
        end
        mail_client.should_receive(:mail) do |opts|
          opts[:to].should == user2.email
          opts[:subject].should == "You've been paired up with timmy!"
          opts[:body].should include("You can email him at tim@example.com")
        end
        mailer.users_assigned([user1, user2])
      end
    end
  end
end
