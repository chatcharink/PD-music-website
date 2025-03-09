class NavigatorBarController < ApplicationController
    def index
        if has_default? <= 0
            set_default = default_menu()
        end
        # @menu = Menu.where(status: ["active", "inactive"])
        @data = Menu.new
    end

    def show_datatable
        respond_to do |format|
            format.html
            format.json { render json: MenuDatatable.new(params, view_context: view_context) }
        end
    end

    def create
        form_menu = params["form_menu"]
        
        begin
            if form_menu["update_id"].blank?
                if !is_duplicate?(form_menu["menu_name"], form_menu["menu_tag"])
                    menu = Menu.create(
                        menu_name: form_menu["menu_name"], 
                        menu_tag: form_menu["menu_tag"],
                        icon: form_menu["menu_icon"],
                        header: form_menu["header"].to_i,
                        footer: form_menu["footer"].to_i,
                        status: "inactive"
                    )
                    save_activity("Add", "Success", "Create menu: #{form_menu["menu_name"].capitalize} successfully")
                    flash[:success] = "Add menu #{form_menu["menu_name"].capitalize} successfully"
                else
                    save_activity("Add", "Fail", "Menu name or tag should not duplicate")
                    flash[:error] = "Fail to create #{form_menu["menu_name"].capitalize} because duplicate menu name or tag"
                end
            else
                if !is_duplicate?(form_menu["menu_name"], form_menu["menu_tag"], form_menu["update_id"])
                    menu = Menu.update(
                        form_menu["update_id"],
                        menu_name: form_menu["menu_name"], 
                        menu_tag: form_menu["menu_tag"],
                        icon: form_menu["menu_icon"],
                        header: form_menu["header"].to_i,
                        footer: form_menu["footer"].to_i,
                        status: "inactive"
                    )
                    save_activity("Edit", "Success", "Update menu: #{form_menu["menu_name"].capitalize} successfully")
                    flash[:success] = "Update menu #{form_menu["menu_name"].capitalize} successfully"
                else
                    save_activity("Edit", "Fail", "Menu name or tag should not duplicate")
                    flash[:error] = "Fail to update #{form_menu["menu_name"].capitalize} because duplicate menu name or tag"
                end
            end
        rescue => e
            p e.message
            p e.backtrace.first
            if form_menu["update_id"].blank?
                save_activity("Add", "Success", "Fail to add menu: #{form_menu["menu_name"].capitalize}")
                flash[:error] = "Fail to add menu #{form_menu["menu_name"].capitalize}. Please contact administator"
            else
                save_activity("Edit", "Success", "Fail to update menu: #{form_menu["menu_name"].capitalize}")
                flash[:error] = "Fail to update menu #{form_menu["menu_name"].capitalize}. Please contact administator"
            end
        end

        redirect_to navigator_path()
    end

    def get_data
        @data = Menu.find(params["id"])
        render(
            partial: "navigator_bar/add_menu",
            formats: [:html, :js, :json, :url_encoded_form]
        )
    end

    def destroy
        begin
            delete_menu = Menu.update(params["id"], status: "pre_delete")
            
            flash["success"] = "Delete #{delete_menu.menu_name} successfully."
            save_activity("Delete", "Success", "Delete #{delete_menu.menu_name} successfully")
        rescue => e
            save_activity("Delete", "Fail", "Fail to delete banner because something went wrong.")
            flash["error"] = "Fail to delete menu. Please contact administrator"
        end
        respond_to do |format|
            format.json { render :json => {status: "success", redirect_url: "#{navigator_path()}"} }
        end
    end

    private
    def has_default?
        Menu.where(status: "active").count
    end

    def default_menu
        Menu.create(
            menu_name: "Home", 
            icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16"><path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4z"/></svg>',
            status: "active"
        )
    end

    def is_duplicate? menu, tag, id = nil
        menu = Menu.where("menu_name = ? or menu_tag = ?", menu, tag)
        menu = menu.where.not(id: id) if id.present?
        return menu.present?
    end
end
