class UserDatatable < ApplicationDatatable
  def_delegators :@view, :session, :user_path, :edit_user_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      name: { source: "User.firstname", cond: :like },
      status: { source: "User.status", cond: :like },
      action: { source: "", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        name: get_name(record.firstname, record.lastname),
        status: get_status(record.status),
        action: get_action(record)
      }
    end
  end

  def get_raw_records
    user = User.select("users.*")
    user = user.where("users.firstname like ? or users.lastname like ?", "%#{params["user_name"]}%", "%#{params["user_name"]}%") if params["user_name"].present?
    user = user.where("users.status = ?", params["status"]) if params["status"].present?
    user = user.order(Arel.sql(%q(
                      case users.status
                      when 'active'  then 1
                      when 'inactive' then 2
                      when 'deleted'  then 3
                      end
                    )))
    user

  end

  def get_name firstname, lastname
    "#{firstname.capitalize} #{lastname}"
  end

  def get_status status
    status_badge = "<span class=\"badge rounded-pill status-#{status}\">#{status.capitalize}</span>"
    status_badge.html_safe
  end

  def get_action user
    actions = []
    actions << "<a href=#{edit_user_path(id: user.id)} class=\"nav-link mx-1 d-inline\">"
    actions << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"currentColor\" class=\"bi bi-pencil-fill icon mx-2\" viewBox=\"0 0 16 16\"><path d=\"M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.5.5 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11z\"/></svg>"
    actions << "</a>"
    # actions << "<a href=#{user_path(id: additional.id)} class=\"nav-link mx-1 d-inline\">"
    actions << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"currentColor\" class=\"bi bi-trash-fill icon mx-2\" viewBox=\"0 0 16 16\" data-bs-toggle=\"modal\" data-bs-target=\"#confirmDeleteDialog\" data-action=\"click->user#setDeleteId\" data-user-url-param=\"#{user_path(id: user.id)}\" data-user-name-param=\"#{user.firstname} #{user.lastname}\"><path d=\"M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0\"/></svg>"
    # actions << "</a>"
    actions.join(' ').html_safe
  end
end
