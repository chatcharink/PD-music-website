class LoginController < ApplicationController
    require "date"
    require "openssl"
    # include LoginHelper

    def index
        return redirect_to navigator_path() if session["current_user"].present?
    end

    def authenicate
        username = params["form_login"]["username"].strip
        password = params["form_login"]["password"]
        @user = User.where(:username => username).limit(1).or(User.where(:email => username).limit(1))
        if @user.present?
            @user.each do |u|
                if u.status != "active"
                    if u.status == "inactive"
                        flash[:error] = "Your account is not activate. Please try again later."
                        save_activity("Login", "Fail", "Login with invalid account")
                    else
                        flash[:error] = "Username not found. Please register and try again later."
                        save_activity("Login", "Fail", "Username not found")
                    end
                    
                    return redirect_to login_path()
                    break
                end
                ecrypt_password = BCrypt::Engine.hash_secret(password, u.salt_password)
                if u.password == ecrypt_password
                    user_info = u
                    user_info["profile_pic"] = u.profile_pic.present? ? url_for(u.profile_pic) : "#{APP_CONFIG[:application_path]}/pictures/no_image.jpg"
                    # permission_role = PermissionAndRole.where(role_id: u.role)
                    session["current_user"] = user_info
                    # session["permission_roles"] = permission_role.pluck(:permission_id)
                    # session["inactive_user"] = User.where(status: "inactive").count if can_view_menu?([6])
                    # User.update(u.id, first_login: 1)
                    flash[:success] = "Login Successfully. Welcome #{u.firstname} to PD music school." #if can_view_menu?([1]) || can_view_menu?([17]) || can_view_menu?([33]) || can_view_menu?([41]) || can_view_menu?([43])
                    save_activity("Login", "Success", "#{u.username} login success")
                    redirect_to navigator_path()
                else
                    flash[:error] = "Your password was wrong. Please try again."
                    save_activity("Login", "Fail", "Login with wrong password")
                    redirect_to login_path(:username => username)
                end
                break
            end
        else
            flash[:error] = "Your username or email not found. Please register and try again later."
            save_activity("Login", "Fail", "Login with invalid username or email")
            redirect_to login_path()
        end
    end

    def logout
        if params["state"]
            flash[:success] = "Force logout because of you session was expired."
            save_activity("Logout", "Success", "Force logout because of you session was expired")
        else
            flash[:success] = "Log out successfully. See you soon"
            save_activity("Logout", "Success", "Log out successfully")
        end
        session.delete "current_user"
        # session.delete "permission_roles"
        # session.delete "inactive_user"
        redirect_to login_path()
    end

    def forgot_password
        render(
            partial: 'login/forgot_password',
            formats: [:html, :js, :json, :url_encoded_form])
    end

    def reset_password
        user = User.find_by(email: params["form_forgot_password"]["email"])
        unless user.blank?
            date = DateTime.now()+1
            
            token = SecureRandom.base36(24) + encrypt(date.strftime("%Y%m%d%H%M%S")) + user.salt_password
            UserMailer.reset_password(user, token).deliver_now
            flash[:success] = "Send email to reset your password succussfully."
            respond_to do |format|
                format.json { render :json => {state: "success", redirect_url: login_url()} }
            end
            # redirect_to login_path()
        else
            respond_to do |format|
                format.json { render :json => {state: "error", message: "Email address not found."} }
            end 
        end
    end

    def new_password
        begin
            date_now = DateTime.now()
            decrypt_date = decrypt(params["token"][24..37])
            token_expired = DateTime.parse(decrypt_date)

            user = User.find_by(salt_password: params["token"][38..-1])
            @user = user.username
            @id = user.id

            if (token_expired - date_now).to_i <= 0
                flash[:error] = "Token already expired. Please reset password again."
                save_activity("Reset password", "Fail", "Cannot reset password because token already expired")
                redirect_to login_path()
            end
        rescue => e
            flash[:error] = "Something was wrong. Please reset password again."
            save_activity("Reset password", "Fail", "Reset password fail")
            redirect_to login_path()
        end
    end

    def change_password
        user_id = params["form_change_password"]["user_id"]
        password = params["form_change_password"]["password"]
        generated_salt_password = BCrypt::Engine.generate_salt
        encrypt_password = BCrypt::Engine.hash_secret(password, generated_salt_password)
        begin
            User.update_password(user_id, generated_salt_password, encrypt_password)
            flash[:success] = "Change password succussfully. Please login to PD music again."
            save_activity("Reset password", "Success", "Reset password successfully")
            redirect_to login_path()
        rescue => e
            p e.message
            p e.backtrace.first
            flash[:error] = "Something went wrong. Please contact to support team."
            save_activity("Reset password", "Fail", "Reset password fail")
            redirect_to login_path()
        end
    end

    private

    def encrypt date
        key = ("a".."z").to_a
        str = []
        date.split("").each do |d|
            str << key[d.to_i]
        end

        str.join("")
    end

    def decrypt data
        key = ("a".."z").to_a
        str = []
        data.split("").each do |d|
            str << key.index(d)
        end

        str.join("")
    end
end
