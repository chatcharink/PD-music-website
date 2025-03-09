class UsersController < ApplicationController
    def show
        respond_to do |format|
            format.html { render "show" }
            format.json { render json: UserDatatable.new(params, view_context: view_context) }
        end
    end

    def new
        @user = User.new
    end

    def create
        is_duplicate = User.where(username: params["user"]["username"]).or(User.where(email: params["user"]["email"]))
        if is_duplicate.blank?
            begin
                generated_salt_password = BCrypt::Engine.generate_salt
                ecrypt_password = BCrypt::Engine.hash_secret(params["user"]["correct_password"], generated_salt_password)
                user = User.insert_user(params["user"], ecrypt_password, generated_salt_password)
                if user
                    flash[:success] = "Create user: #{params["user"]["username"]} successfully."
                    save_activity("Add user", "Success", "Create user #{params["user"]["username"]} successfully")
                    # status = "success"
                    # message = "Create user: #{params["user"]["username"]} successfully."
                else
                    flash[:error] = "Cannot create user: #{params["user"]["username"]} becuase something in database went wrong"
                    save_activity("Add", "Fail", "Cannot create #{params["user"]["username"]}")
                    # status = "error"
                    # message = "Cannot create user. Please contact admin"
                end
            rescue => e
                save_activity("Add", "Fail", "Cannot create #{params["user"]["username"]}")
                flash[:error] = "Cannot create user: #{params["user"]["username"]} becuase something went wrong"
                # status = "error"
                # message = "Something was wrong. Please contact admin"
            end
        else
            save_activity("Add", "Fail", "Cannot create #{params["user"]["username"]} because username or email has already exists")
            flash[:error] = "Username or email has already exists."
            # status = "error"
            # message = "Username or email has already exists."
        end

        redirect_to user_path()
    end

    def edit
        @user = User.find(params["id"])
    end

    def update
        begin
            is_duplicate = User.where(email: params["user"]["email"]).where.not(id: params["id"])
            if is_duplicate.blank?
                user = User.update_profile(params["id"], params["user"])
                flash[:success] = "Update user: #{user.username} successfully."
                save_activity("Update", "Success", "Update user : #{user.username} successfully")
            else
                save_activity("Update", "Fail", "Cannot update user because username or email has already exists")
                flash[:error] = "Username or email has already exists."
            end
        rescue => e
            save_activity("Update", "Fail", "Cannot update user")
            flash[:error] = "Something was wrong. Please contact admin"
        end
        
        redirect_to user_path()
    end

    def destroy
        begin
            user = User.find(params["id"]).update(status: "deleted")
            state = "success"
            save_activity("Delete", "Success", "Delete user: #{params["name"]} successfully")
            flash[:success] = "Delete user: #{user.username} successfully."
        rescue => e
            p e.message
            p e.backtrace.first
            state = "error"
            save_activity("Delete", "Fail", "Cannot delete user")
            flash[:error] = "Fail to delete user. Please contact administator"
        end

        respond_to do |format|
            format.json { render :json => {status: state, redirect_url: "#{user_url()}"} }
        end
    end
end
