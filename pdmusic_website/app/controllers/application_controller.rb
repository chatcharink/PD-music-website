class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    helper_method :is_user_logged_in?
    before_action :is_user_logged_in? , :except => [:show_content, :show_sub_content]
    add_flash_types :info, :error, :success, :warning
    require "date"
    require "json"
    require "socket"

    def is_user_logged_in?
        if session["current_user"].blank? && params[:controller] != "login"
            flash[:success] = "Force log out because session timeout"
            return redirect_to login_path()
        end
    end

    def save_activity action, result, detail
        if session["current_user"].blank?
            user = nil
            role = nil
        else
            user = session["current_user"]["id"]
            role = session["current_user"]["role"]
        end
        
        agent = request.user_agent
        device ||= agent.slice!(agent.index("(")+1..agent.index(")")-1).gsub(';','')
        ip_addr = request.remote_ip

        ActivityLog.create(user_id: user,
            user_role_id: role,
            device: device,
            detected_ip: ip_addr,
            action_name: action,
            action_result: result,
            component: "PD music",
            action_detail: detail,
            action_datetime: DateTime.now()
        )
    end

    def public_content
        begin
            content = Content.where(status: "inactive")
            delete_content = Content.where(status: "pre_delete")
            content.update(status: "active")
            delete_content.update(status: "deleted")

            banner = Banner.where(status: "inactive")
            delete_banner = Banner.where(status: "pre_delete")
            banner.update(status: "active")
            delete_banner.update(status: "deleted")

            menu = Menu.where(status: "inactive")
            delete_menu = Menu.where(status: "pre_delete")
            menu.update(status: "active")
            delete_menu.update(status: "deleted")

            additional = AdditionalContent.where(status: "inactive")
            delete_additional = AdditionalContent.where(status: "pre_delete")
            additional.update(status: "active")
            delete_additional.update(status: "deleted")

            save_activity("Public", "Success", "Public content successfully")
            flash[:success] = "Content is already update !!"
        rescue => e
            save_activity("Public", "Fail", "Fail to public content because something went wrong.")
            flash[:error] = "Fail to update content. Please contact administrator"
        end
        redirect_to "#{content_url()}/home"
    end

    def show_content
        menu = params["menu"]
        menu = "home" if menu.blank?
        @banner = Banner.where(menu_tag: menu, status: "active", cover_id: nil).order("created_at")
        @content_data = Content.select("contents.*, categories.category_name").where(menu: menu, status: "active")
        @content_data = @content_data.joins("left join categories on categories.id = contents.categories_id").order("created_at")
        @additional = AdditionalContent.where(status: "active").order("created_at").index_by(&:id)
        if @content_data.present?
            if @content_data.first.content_format.to_i == 2
                @sub_content = Hash.new
                @content_data.each do |c|
                    next if c.is_child_of.present?
                    tab_name = c.category_name.blank? ? "no_tab_name" : c.category_name
                    @sub_content[tab_name] ||= []
                    sub_content = Hash.new
                    sub_content["title_content"] = c.title_content
                    sub_content["image"] = c.image
                    sub_content["id"] = c.id
                    @sub_content[tab_name] << sub_content
                end
            end
        end
        # @tab = @content_data.select(:categories).group(:categories)
        render "frontend/show_content"
    end

    def show_sub_content
        menu = params["menu"]
        menu = "home" if menu.blank?
        @banner = Banner.where(menu_tag: menu, cover_id: params["cover_id"], status: "active").order("created_at")
        @content_data = Content.where(menu: menu, is_child_of: params["cover_id"], status: "active").order("created_at")
        @additional = AdditionalContent.where(status: "active").order("created_at").index_by(&:id)
        render "frontend/show_sub_content"
    end
end
