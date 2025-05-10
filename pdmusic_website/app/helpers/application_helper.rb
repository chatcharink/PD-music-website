module ApplicationHelper
    def get_side_menu
        Menu.where(status: "active")
    end

    def read_yml_setting
        read = YAML.load_file("#{Rails.root}/lib/general_setting.yml")
        read
    end
end
