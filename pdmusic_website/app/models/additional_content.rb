class AdditionalContent < ApplicationRecord
    has_one_attached :image

    def self.create_school form_school, menu
        school = AdditionalContent.create(
            title: form_school["title"],
            image: form_school["image"],
            url: form_school["url"],
            menu: menu,
            status: "inactive"
        )
    end

    def self.update_school form_school
        school = AdditionalContent.update(
            form_school["update_id"],
            title: form_school["title"],
            url: form_school["url"]
        )
    end

    def self.update_image form_school
        image = AdditionalContent.update(
            form_school["update_id"],
            image: form_school["image"]
        )
    end

    def self.create_feedback form_feedback, menu
        feedback = AdditionalContent.create(
            title: form_feedback["title"],
            html_content: form_feedback["html_content"],
            menu: menu,
            status: "inactive"
        )
    end

    def self.update_feedback form_feedback
        feedback = AdditionalContent.update(
            form_feedback["update_id"],
            title: form_feedback["title"],
            html_content: form_feedback["html_content"]
        )
    end

    def self.create_gallery form_gallery, menu
        gallery = AdditionalContent.create(
            title: form_gallery["title"],
            image: form_gallery["image"],
            menu: menu,
            status: "inactive"
        )
        gallery
    end

    def self.create_sub_gallery image, gallery_id, menu
        gallery = AdditionalContent.create(
            title: "filename",
            image: image,
            menu: menu,
            gallery_id: gallery_id,
            status: "inactive"
        )
        gallery
    end

    def self.update_gallery form_gallery
        gallery = AdditionalContent.update(
            form_gallery["update_id"],
            title: form_gallery["title"]
        )
    end

    def self.delete_gallery form_gallery
        gallery = AdditionalContent.where(menu: "gallery", gallery_id: form_gallery["update_id"])
        
        exist_sub_content = form_gallery["arr_gallery_id"].blank? ? [] : form_gallery["arr_gallery_id"].split(",").map(&:to_i)
        db_gallery = gallery.pluck(:id)
        diff = db_gallery - exist_sub_content
        if diff.length > 0
            AdditionalContent.where(id: diff).destroy_all
        end
    end
end
