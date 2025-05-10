module ContentHelper
    def get_additional_data
        additional = AdditionalContent.where(gallery_id: nil, status: ["active", "inactive"])
        arr_select = []
        arr_text = []
        additional.each do |add_con|
            name = add_con.menu == "gallery" ? "#{add_con.menu.capitalize} - #{add_con.title}" : add_con.menu.capitalize
            option = [name, add_con.id] unless arr_text.include?(name)
            arr_select << option
            arr_text << name
        end
        arr_select.uniq!.compact! if arr_select.length > 0
        arr_select
    end
end
