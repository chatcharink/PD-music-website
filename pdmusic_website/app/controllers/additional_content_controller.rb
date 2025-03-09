class AdditionalContentController < ApplicationController
    def index
        @content = AdditionalContent.new
        render "additional_content/index"
    end

    def show_table
        case params["menu"]
        when "school"
            respond_to do |format|
                format.html
                format.json { render json: SchoolDatatable.new(params, view_context: view_context) }
            end
        when "feedback"
            respond_to do |format|
                format.html
                format.json { render json: FeedbackDatatable.new(params, view_context: view_context) }
            end
        when "gallery"
            respond_to do |format|
                format.html
                format.json { render json: GalleryDatatable.new(params, view_context: view_context) }
            end
        end
    end

    def get_additional_data
        content = AdditionalContent.find(params["id"])
        if params["menu"] == "gallery"
            gallery = AdditionalContent.where(gallery_id: params["id"])
            render(
                partial: "additional_content/#{params["menu"]}_dialog",
                formats: [:html, :js, :json, :url_encoded_form],
                locals: {menu: params["menu"], content: content, gallery: gallery}
            )
        else
            render(
                partial: "additional_content/#{params["menu"]}_dialog",
                formats: [:html, :js, :json, :url_encoded_form],
                locals: {menu: params["menu"], content: content}
            )
        end
    end

    def update_additional
        case params["menu"]
        when "school"
            update_school(params["form_school"])
        when "feedback"
            update_feedback(params["form_feedback"])
        when "gallery"
            update_gallery(params["form_gallery"])
        end

        redirect_to "#{additional_url()}/#{params["menu"]}"
    end

    def delete_additional_content
        begin
            del_content = AdditionalContent.update(params["id"],
                            status: "pre_delete")
            del_sub_content = AdditionalContent.where(gallery_id: params["id"]).update_all(status: "pre_delete")
            state = "success"
            flash["success"] = "Delete #{params["menu"]} successfully."
            save_activity("Delete", "Success", "Delete #{params["menu"]} successfully")
        rescue => e
            state = "error"
            save_activity("Delete", "Fail", "Fail to delete banner because something went wrong.")
            flash["error"] = "Fail to Delete #{params["menu"]}. Please contact administrator"
        end
        respond_to do |format|
            format.json { render :json => {status: state, redirect_url: "#{additional_url()}/#{params["menu"]}"} }
        end
    end

    private
    def update_school form_school
        begin
            if form_school["update_id"].blank?
                content = AdditionalContent.create_school(form_school, params["menu"])
                flash[:success] = "Create school successfully."
                save_activity("Add", "Success", "Create school : #{form_school["title"]} successfully")
            else
                content = AdditionalContent.update_school(form_school)
                content.update(image: form_school["image"]) if form_school["is_image_update"] == "true"
                flash[:success] = "Update school successfully."
                save_activity("Edit", "Success", "Update content : #{form_school["title"]}")
            end
        rescue => e
            if form_school["update_id"].blank?
                flash[:error] = "Fail to create school because something went wrong."
                save_activity("Add", "Fail", "Fail to create school : #{form_school["title"]}")
            else
                flash[:error] = "Fail to update school because something went wrong."
                save_activity("Edit", "Fail", "Fail to update content : #{form_school["title"]}")
            end
        end
    end

    def update_feedback form_feedback
        begin
            if form_feedback["update_id"].blank?
                content = AdditionalContent.create_feedback(form_feedback, params["menu"])
                flash[:success] = "Create feedback successfully."
                save_activity("Add", "Success", "Create feedback successfully")
            else
                content = AdditionalContent.update_feedback(form_feedback)
                flash[:success] = "Update feedback successfully."
                save_activity("Edit", "Success", "Update feedback successfully")
            end
        rescue => e
            if form_feedback["update_id"].blank?
                flash[:error] = "Fail to create feedback because something went wrong."
                save_activity("Add", "Fail", "Fail to create feedback")
            else
                flash[:error] = "Fail to update feedback because something went wrong."
                save_activity("Edit", "Fail", "Fail to update feedback")
            end
        end
    end

    def update_gallery form_gallery
        begin
            if form_gallery["update_id"].blank?
                content = AdditionalContent.create_gallery(form_gallery, params["menu"])
                parent_id = content.id
                flash[:success] = "Create gallery successfully"
                save_activity("Add", "Success", "Create gallery successfully")
            else
                content = AdditionalContent.update_gallery(form_gallery)
                content.update(image: form_gallery["image"]) if form_gallery["is_image_update"] == "true"
                parent_id = form_gallery["update_id"]
                del_sub_content = AdditionalContent.delete_gallery(form_gallery)
                
                flash[:success] = "Update gallery successfully."
                save_activity("Edit", "Success", "Update gallery successfully")
            end
            if form_gallery["gallery"].present? 
                form_gallery["gallery"].each do |k, v|
                    sub_content = AdditionalContent.create_sub_gallery(v, parent_id, params["menu"])
                end
            end
        rescue => e
            p e.message
            p e.backtrace
            if form_gallery["update_id"].blank?
                flash[:error] = "Fail to create gallery because something went wrong."
                save_activity("Add", "Fail", "Fail to create gallery")
            else
                flash[:error] = "Fail to update gallery because something went wrong."
                save_activity("Edit", "Fail", "Fail to update gallery")
            end
        end
    end
end
