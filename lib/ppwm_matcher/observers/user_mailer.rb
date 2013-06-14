module PpwmMatcher
  class UserMailer
    def initialize(mail_client)
      @client = mail_client
    end

    def users_assigned(users)
      if users.length == 2
        users.permutation.each do |user, paired_user|
          @client.mail(mail_options(user, paired_user))
        end
      end
    end

    private
    def mail_options(user, paired_user)
      { :to      => user.email,
        :subject => "You've been paired up with #{paired_user.github_login}!",
        :body    => mail_body(user, paired_user) }
    end

    def mail_body(user, paired_user)
      return <<-EOD
Hi #{user.github_login},

You've been paired up with #{paired_user.github_login}! You can email them at #{paired_user.email}.

Happy hacking!

--
Sent by http://pairprogramwith.me
      EOD
    end
  end
end
