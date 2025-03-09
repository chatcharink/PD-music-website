import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'

export default class extends Controller {
    connect() {
        // this.element.textContent = "Hello World!"
        document.getElementById("side-menu-activity-logs").classList.add("active");

        $("#table-activity-list").DataTable({
            pagingType: "full_numbers",    
            pageLength: 15,
            destroy: true,
            processing: true,
            serverSide: true,
            ordering: false,
            dom: '<tp>',
            ajax: { url: $("#table-activity-list").data('url') },
            columnDefs: [{'targets': [0, 1, 4], 'className': "truncate"}],
            columns: [
                { data: 'name' },
                { data: 'device' },
                { data: 'action' },
                { data: 'result' },
                { data: 'detail' },
                { data: 'datetime' }
            ],
            rowCallback: function(row, data){
                console.log(data);
                $('td:eq(0)', row).attr("data-bs-toggle", "tooltip");
                $('td:eq(0)', row).attr("data-bs-placement", "top");
                $('td:eq(0)', row).prop("title", data["name"]);
                $('td:eq(1)', row).attr("data-bs-toggle", "tooltip");
                $('td:eq(1)', row).attr("data-bs-placement", "top");
                $('td:eq(1)', row).prop("title", data["device"]);
                $('td:eq(4)', row).attr("data-bs-toggle", "tooltip");
                $('td:eq(4)', row).attr("data-bs-placement", "top");
                $('td:eq(4)', row).prop("title", data["detail"]);
            },
            drawCallback: function(){
                let tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
                    let tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl,{
                        'customClass': 'custom-tooltip'
                    })
                })
            }
        });
        // this.showToolsTip();
    }

    // showToolsTip(){
        
    // }

}
