class Banner < ApplicationRecord
    has_one_attached :banner_image

    def self.create_banner params
        Banner.create(banner_image: params["banner"]["banner"], 
            menu_tag: params["menu"], 
            cover_id: params["cover_id"], 
            status: "inactive"
        )
    end
end
