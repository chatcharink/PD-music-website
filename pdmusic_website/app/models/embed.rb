class Embed < ApplicationRecord
    include ActionText::Attachable
   
    # def self.oembed
    #     OEmbed::Providers.register_all
    #     return OEmbed::Providers.get(url, {width: '500px'})
    # end

    def to_trix_content_attachment_partial_path
        "content/embed"
    end
end
