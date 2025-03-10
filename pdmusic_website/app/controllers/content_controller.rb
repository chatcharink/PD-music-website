class ContentController < ApplicationController
    def upload_banner
        begin
            banner = Banner.create_banner(params)

            @banner = Banner.where(menu_tag: params["menu"]).where.not(status: ["deleted", "pre_delete"])
            @banner = params["cover_id"].present? ? @banner.where(cover_id: params["cover_id"]) : @banner.where(cover_id: nil)
            render(
                partial: "content/upload_image",
                formats: [:html, :js, :json, :url_encoded_form]
                # locals: {@banner: @banner}
            )
        rescue => e
            message = "Fail to upload banner. Please contact administrator."
            save_activity("Upload", "Fail", "Fail to upload banner because something went wrong.")
            respond_to do |format|
                format.json { render :json => {status: "error", message: message} }
            end
        end
    end

    def change_format
        ## Delete old content
        old_content = Content.where(menu: params["menu"]).where.not(content_format: params["content_format"])
        old_content.update_all(status: "pre_delete")
        
        @content_data = Content.new
        @content = Content.select("contents.*, categories.category_name")
        @content = @content.where(menu: params["menu"], content_format: params["content_format"], is_child_of: nil).where.not(status: ["deleted", "pre_delete"])
        @content = @content.joins("left join categories on categories.id = contents.categories_id")
        @additional_content = AdditionalContent.where.not(status: ["deleted", "pre_delete"]).index_by(&:id)
        @content_format = params["format"].to_i
        @tab = Category.where(status: "active")
        render(
            partial: "content/format#{params["content_format"]}",
            formats: [:html, :js, :json, :url_encoded_form]
            # locals: {@banner: @banner}
        )
    end

    def add_content
        params["menu"] = "home" if params["menu"].blank?
        @banner = Banner.where(menu_tag: params["menu"], cover_id: nil).where.not(status: ["deleted", "pre_delete"]).order("created_at")
        @content_data = Content.new
        @content = Content.select("contents.*,  categories.category_name")
        @content = @content.where(menu: params["menu"], is_child_of: nil).where.not(status: ["deleted", "pre_delete"])
        @content = @content.joins("left join categories on categories.id = contents.categories_id").order("created_at")
        @additional_content = AdditionalContent.where.not(status: ["deleted", "pre_delete"]).order("menu").index_by(&:id)
        @tab = Category.where(status: "active")
        if @content.blank?
            @content_format = 1
        else
            @content_format = @content.first.content_format.to_i
        end
        render "content/content"
    end

    def get_embed
        @embed = Embed.find_or_create_by(url: params[:content])
        # p @embed.attachable_sgid
        content = ContentController.render(partial: 'content/embed',
                                            locals: { embed: @embed },
                                            formats: :html)
        render json: { content: content, sgid: @embed.attachable_sgid }
    end

    def create_content
        begin
            form_content = params["content"]
            if form_content["update_id"].blank?
                content = Content.create_content(params)
                flash[:success] = "Create content Successfully."
                save_activity("Add", "Success", "Create content : #{form_content["title_content"]} of menu : #{params["menu"].capitalize} successfully")
            else
                content = Content.update_content(params)
                Content.update_image(params) if form_content["is_image_update"] == "true"
                flash[:success] = "Update content Successfully."
                save_activity("Edit", "Success", "Update content : #{form_content["title_content"]} of menu : #{params["menu"].capitalize} successfully")
            end
        rescue => e
            p e.message
            p e.backtrace.first
            if form_content["update_id"].blank?
                flash[:error] = "Fail to create content because something went wrong."
                save_activity("Add", "Fail", "Fail to create content : #{form_content["title_content"]} of menu : #{params["menu"].capitalize}")
            else
                flash[:error] = "Fail to update content because something went wrong."
                save_activity("Edit", "Fail", "Fail to update content : #{form_content["title_content"]} of menu : #{params["menu"].capitalize}")
            end
        end
        redirect_to "#{content_url()}/#{params["menu"]}/#{params["cover_id"]}"
    end

    def get_content
        @content_data = Content.find(params["id"])
        render_file = params["additional"] == "true" ? "content/add_additional_content" : "content/add_content"
        render(
            partial: render_file,
            formats: [:html, :js, :json, :url_encoded_form],
            locals: {menu: params["menu"], cover: params["cover_id"]}
        )
    end

    def delete_banner
        begin
            banner = Banner.find(params["id"])
            banner.update(status: "pre_delete")

            @banner = Banner.where(menu_tag: params["menu"]).where.not(status: ["deleted", "pre_delete"])
            cover_msg = ""
            if params["cover_id"].present?
                @banner = @banner.where(cover_id: params["cover_id"])
                cover_title = Content.find(params["cover_id"]).title_content
                cover_msg = " in cover : #{cover_title} "
            end
            render(
                partial: "content/upload_image",
                formats: [:html, :js, :json, :url_encoded_form]
                # locals: {@banner: @banner}
            )
            # flash[:success] = "Delete banner of menu : #{params["menu"].capitalize}#{cover_msg}successfully."
            # save_activity("Delete", "Success", "Delete banner of menu : #{params["menu"].capitalize}#{cover_msg}successfully")
        rescue => e
            message = "Fail to delete banner. Please contact administrator."
            save_activity("Delete", "Fail", "Fail to delete banner because something went wrong.")
            respond_to do |format|
                format.json { render :json => {status: "error", message: message} }
            end
        end
        
    end

    def get_cover
        @content_data = Content.find(params["id"])
        @tab = Category.where(status: "active")
        selected_tab = @content_data.categories_id.blank? ? "" : Category.find(@content_data.categories_id).category_name
        render(
            partial: "content/add_cover",
            formats: [:html, :js, :json, :url_encoded_form],
            locals: {menu: params["menu"], cover: params["cover_id"], selected_tab: selected_tab}
        )
    end

    def delete_content
        begin
            content = Content.find(params["id"])
            content.update(status: "pre_delete")

            @content_data = Content.new
            if params["content"] == "cover"
                html_render = "format2"
                @content = Content.where(is_child_of: params["id"]).where.not(status: ["deleted", "pre_delete"])
            else
                html_render = "format1"
                @content = Content.where(menu: params["menu"], is_child_of: nil).where.not(status: ["deleted", "pre_delete"])
            end
            status = "success"
            flash[:success] = "Delete content of menu : #{params["menu"].capitalize} successfully."
            save_activity("Delete", "Success", "Delete content of menu : #{params["menu"].capitalize} successfully")
        rescue => e
            flash[:error] = "Fail to delete content. Please contact administrator."
            save_activity("Delete", "Fail", "Fail to delete content because something went wrong.")
            status = "error"
        end
        respond_to do |format|
            format.json { render :json => {status: status, redirect_url: "#{content_url()}/#{params["menu"]}/#{params["cover_id"]}"} }
        end
    end

    def sub_content
        @banner = Banner.where(cover_id: params["cover_id"]).where.not(status: ["deleted", "pre_delete"])
        @content_data = Content.new
        @content = Content.select("contents.*, categories.category_name")
        @content = @content.where(is_child_of: params["cover_id"]).where.not(status: ["deleted", "pre_delete"])
        @content = @content.joins("left join categories on categories.id = contents.categories_id")
        @additional_content = AdditionalContent.where.not(status: ["deleted", "pre_delete"]).index_by(&:id)
        render "content/sub_content"
    end
end
