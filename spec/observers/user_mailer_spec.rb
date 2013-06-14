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
      it "expects mail to be sent" do
        users = [ double("User", name: 'Tim Bower', email: 'tim@example.com', github_login: 'timmy') ,
                  double("User", name: 'Bob Timberland', email: 'bob@example.com', github_login: 'bobby') ]

        users.permutation.each do |user, pair|
          mail_client.should_receive(:mail) do |opts|
            opts[:from].should == 'matcher@pairprogramwith.me'
            opts[:reply_to].should == pair.email
            opts[:to].should == user.email
            opts[:subject].should == "You've been paired up with #{pair.github_login}!"
            opts[:body].should include("Hi #{user.name},")
            opts[:body].should include("You can email them at #{pair.email}")
            opts[:body].should include("You've been paired up with #{pair.name}")
          end
        end

        mailer.users_assigned(users)
      end

      it "uses github_login if name isn't present" do
        users = [ double("User", name: nil, email: 'tim@example.com', github_login: 'timmy') ,
                  double("User", name: nil, email: 'bob@example.com', github_login: 'bobby') ]

        users.permutation.each do |user, pair|
          mail_client.should_receive(:mail) do |opts|
            opts[:body].should include("Hi #{user.github_login},")
            opts[:body].should include("You've been paired up with #{pair.github_login}")
          end
        end

        mailer.users_assigned(users)
      end
    end
  end
end
