class UserMailer < ActionMailer::Base
    default from: "Accent Global <vyasa@accent.global>"

    def signup_email(user)
        @user = user
        @twitter_message = "#Chiropractic is evolving. Excited for @accentconcierge to launch."

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
