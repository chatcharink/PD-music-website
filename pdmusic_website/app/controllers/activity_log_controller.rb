class ActivityLogController < ApplicationController
    def index

    end

    def datatable
        respond_to do |format|
            format.html
            format.json { render json: ActivityLogDatatable.new(params, view_context: view_context) }
        end
    end
end
