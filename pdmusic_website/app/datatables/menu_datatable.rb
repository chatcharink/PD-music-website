class MenuDatatable < ApplicationDatatable
  def_delegators :@view, :session, :get_navigator_data_path, :navigator_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      menuName: { source: "Menu.menu_name", cond: :like },
      header: { source: "Menu.header", cond: :eq },
      footer: { source: "Menu.footer", cond: :eq },
      status: { source: "Menu.status", cond: :eq },
      action: { source: "Menu.id", cond: :like },
    }
  end

  def data
    records.map do |record|
      {
        menuName: record.menu_name,
        header: generate_header_footer_state(record.header),
        footer: generate_header_footer_state(record.footer),
        status: get_status(record.status),
        action: get_action(record)
      }
    end
  end

  def get_raw_records
    menu = Menu.where.not(status: "deleted")
    menu = menu.where("menus.menu_name like ?", "%#{params["name"]}%") if params["name"].present?
    menu = menu.where(status: params["status"]) if params["status"].present?
    menu = menu.order(Arel.sql(%q(
      case menus.status
        when 'active'  then 1
        when 'inactive' then 2
        when 'pre_delete'  then 3
      end
    )))
    menu = menu.order("created_at ASC")
    menu
  end

  def generate_header_footer_state status
    state = []
    if status.to_i > 0
      state << '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill status-active" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg>'
    else
      state << '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle-fill status-deleted" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293z"/></svg>'
    end
    state.join(' ').html_safe
  end

  def get_status status
    status_text = status == "pre_delete" ? "Deleted" : status.capitalize
    status_badge = "<span class=\"badge rounded-pill status-#{status}\">#{status_text}</span>"
    status_badge.html_safe
  end

  def get_action menu
    actions = []
    actions << "<button type=\"button\" class=\"btn btn-primary d-none\" id=\"edit-menu-btn\" data-bs-toggle=\"modal\" data-bs-target=\"#addMenu\">Update menu</button><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-pencil-fill\" viewBox=\"0 0 16 16\" data-action=\"click->menu#editMenu\" data-menu-url-param=\"#{ get_navigator_data_path(id: menu.id) }\"><path d=\"M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.5.5 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11z\"/></svg>"
    actions << "<div class=\"d-inline mx-2\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-trash-fill\" viewBox=\"0 0 16 16\" data-action=\"click->menu#confirmDelete\" data-menu-url-param=\"#{ navigator_path(id: menu.id) }\" data-menu-menu-name-param=\"#{ menu.menu_name }\" data-bs-toggle=\"modal\" data-bs-target=\"#confirmDeleteDialog\"><path d=\"M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0\"/></svg></div>"
    actions.join(' ').html_safe
  end
end
