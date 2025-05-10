class FeedbackDatatable < ApplicationDatatable
  def_delegators :@view, :session, :get_additional_data_path, :additional_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      feedback: { source: "AdditionalContent.html_content", cond: :like },
      status: { source: "AdditionalContent.status", cond: :eq },
      action: { source: "AdditionalContent.id", cond: :like },
    }
  end


  def data
    records.map do |record|
      {
        feedback: record.html_content.html_safe,
        status: get_status(record.status),
        action: get_action(record)
      }
    end
  end

  def get_raw_records
    additional = AdditionalContent.where(menu: "feedback", status: ["active", "inactive"])
    additional = additional.order(Arel.sql(%q(
      case additional_contents.status
      when 'inactive' then 1
      when 'active'  then 2
      when 'deleted'  then 3
      end
    )))
    additional = additional.order("updated_at DESC")
    additional
  end

  def get_status status
    status_badge = "<span class=\"badge rounded-pill status-#{status}\">#{status.capitalize}</span>"
    status_badge.html_safe
  end

  def get_action additional
    actions = []
    actions << "<button type=\"button\" class=\"btn btn-primary d-none\" id=\"edit-feedback-btn\" data-bs-toggle=\"modal\" data-bs-target=\"#addFeedback\">Update content</button>"
    actions << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"currentColor\" class=\"bi bi-pencil-fill icon mx-2\" viewBox=\"0 0 16 16\" data-action=\"click->feedback#editFeedback\" data-feedback-url-param=\"#{ get_additional_data_path(id: additional.id, menu: additional.menu)}\"><path d=\"M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.5.5 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11z\"/></svg>"
    actions << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"currentColor\" class=\"bi bi-trash-fill icon mx-2\" viewBox=\"0 0 16 16\" data-action=\"click->feedback#confirmDelete\" data-feedback-url-param=\"#{ additional_path(id: additional.id, menu: additional.menu)}\" data-feedback-menu-name-param=\"#{additional.menu}\" data-bs-toggle=\"modal\" data-bs-target=\"#confirmDeleteDialog\" ><path d=\"M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0\"/></svg>"
    actions.join(' ').html_safe
  end

end
