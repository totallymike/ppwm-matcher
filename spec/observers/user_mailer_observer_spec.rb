module PpwmMatcher
  describe UserMailer do
    let(:mail_client) { double("Pony", mail: true) }  # Double Pony? Hehe.
    let(:observer)    { UserMailer.new(mail_client) }

    context "when given no users" do
      it "expects no mail to be sent" do
        mail_client.should_not_receive(:mail)
        observer.users_assigned([])
      end
    end

    context "when given a single user" do
      it "expects no mail to be sent" do
        mail_client.should_not_receive(:mail)
        observer.users_assigned([double("User")])
      end
    end

    context "when given two users" do
      let(:user1) { double("User", email: 'tim@example.com', github_login: 'timmy') }
      let(:user2) { double("User", email: 'bob@example.com', github_login: 'bobby') }

      it "expects mail to be sent" do
        mail_client.should_receive(:mail).with(to: user1.email, subject: "You've been paired up with timmy!")
        mail_client.should_receive(:mail).with(to: user2.email, subject: "You've been paired up with bobby!")
        observer.users_assigned([user1, user2])
      end
    end
  end
end
