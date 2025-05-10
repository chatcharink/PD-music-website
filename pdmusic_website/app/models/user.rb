class User < ApplicationRecord
    def self.insert_user form, password, salt_password
        user = User.create(username: form["username"],
            password: password,
            salt_password: salt_password,
            firstname: form["firstname"],
            lastname: form["lastname"],
            status: form["status"],
            email: form["email"],
            phone_number: form["phone_number"]
        )
        user
    end

    def self.update_profile id, form
        user = User.update(id, 
            firstname: form["firstname"],
            lastname: form["lastname"],
            status: form["status"],
            email: form["email"],
            phone_number: form["phone_number"],
        )
        user
    end

    def self.update_password id, salt_password, password
        user = User.update(id, salt_password: salt_password, password: password)
        user
    end
end
