class UserMailer < ApplicationMailer
    def reset_password user, token
        @user = user
        @token = token
        mail(to: @user.email, subject: "Reset password")
    end
end
