class Content < ApplicationRecord
    include ActionText::Attachable
    # require 'oembed'
    has_one_attached :image
    has_rich_text :content

    def self.create_content params
        tab_id = nil
        if params["content"]["category"].present?
            tab_id = find_tab_id(params["content"]["category"])
        end
        json_table = params["content"]["table"].blank? ? nil : JSON.parse(params["content"]["table"].to_json)
        content = Content.create(
            title_content: params["content"]["title_content"],
            title_url: params["content"]["title_url"],
            url: params["content"]["url"],
            image: params["content"]["image"],
            content: params["content"]["content"],
            content_format: params["content"]["format"],
            menu: params["menu"],
            categories_id: tab_id,
            is_child_of: params["content"]["is_child_of"],
            additional_content_id: params["content"]["additional_id"],
            table: json_table,
            status: "inactive"
        )
        content
    end

    def self.update_content params
        tab_id = nil
        if params["content"]["category"].present?
            tab_id = find_tab_id(params["content"]["category"])
        end

        if params["content"]["format"].to_i == 1
            delete_child = delete_child_content(params["content"]["update_id"])
        end
        
        json_table = params["content"]["table"].blank? ? nil : JSON.parse(params["content"]["table"].to_json)
        content = Content.update(params["content"]["update_id"],
            title_content: params["content"]["title_content"],
            title_url: params["content"]["title_url"],
            url: params["content"]["url"],
            content: params["content"]["content"],
            content_format: params["content"]["format"],
            categories_id: tab_id,
            additional_content_id: params["content"]["additional_id"],
            table: json_table,
            status: "inactive"
        )
    end

    def self.update_image params
        content = Content.update(params["content"]["update_id"],
            image: params["content"]["image"]
        )
        content
    end

    def to_trix_content_attachment_partial_path
        "content/embed"
    end

    private
    def self.find_tab_id category
        has_category = Category.find_by(category_name: category)
        if has_category.blank?
            tab = Category.create(category_name: category, status: "active")
            tab_id = tab.id
        else
            tab_id = has_category.id
        end
        tab_id
    end

    def self.delete_child_content parent_id
        child_content = Content.where(is_child_of: parent_id)
        child_content.update_all(status: "pre_delete")
    end
end
