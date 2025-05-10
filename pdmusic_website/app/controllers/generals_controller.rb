class GeneralsController < ApplicationController
    before_action :is_user_logged_in? , :except => [:index]
    require 'yaml'

    def index
        @banner = Banner.where(menu_tag: "home", status: "active")
        @setting = read_yml_setting()
        render "frontend/contact_us"
    end
    
    def new
        @setting = read_yml_setting()
    end

    def create
        begin
            data = read_yml_setting()
            params["form_general"].each do |k, v|
                data[params["tab"]][k] = v    
            end
            write_yml_setting(data)
            flash[:success] = "Update general setting successfully"
        rescue => e
            p e.message
            p e.backtrace.first
            flash[:error] = "Fail to update general setting. Please contact administator"
        end
        redirect_to new_general_path()
    end

    private
    def read_yml_setting
        read = YAML.load_file("#{Rails.root}/lib/general_setting.yml")
        read
    end

    def write_yml_setting data
        File.open("#{Rails.root}/lib/general_setting.yml", 'w') {|f| f.write data.to_yaml }
    end
end
