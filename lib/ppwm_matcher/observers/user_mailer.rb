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
      { :from    => 'matcher@pairprogramwith.me',
        :to      => user.email,
        :reply_to => paired_user.email,
        :subject => "You've been paired up with #{paired_user.github_login}!",
        :body    => mail_body(user, paired_user) }
    end

    def mail_body(user, paired_user)
      return <<-EOD
Hi #{user.name || user.github_login},

You've been paired up with #{pair_name_for paired_user}! You can email them at #{paired_user.email} (or just reply to this email).

Happy hacking!

--
Sent by http://pairprogramwith.me
      EOD
    end

    def pair_name_for(paired_user)
      if paired_user.name
        "#{paired_user.name} (gh: #{paired_user.github_login})"
      else
        "#{paired_user.github_login}"
      end
    end
  end
end
