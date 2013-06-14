module PpwmMatcher
  class UserMailer
    def initialize(mail_client)
      @client = mail_client
    end

    def users_assigned(users)
      if users.length == 2
        users.each do |user|
          @client.mail(:to => user.email, :subject => "You've been paired up with #{user.github_login}!")
        end
      end
    end
  end
end
