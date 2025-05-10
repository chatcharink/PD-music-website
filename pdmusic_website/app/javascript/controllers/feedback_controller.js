import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'

export default class extends Controller {
    connect(){
        let parent_menu = document.getElementById("addtional-content-menu");
        if (!parent_menu.classList.contains("show")){
            parent_menu.classList.add("show");
            this.toggleIcon();
        }
        document.getElementById("side-menu-feedback").classList.add("active");

        $("#table-feedback-list").DataTable({
            pagingType: "full_numbers",    
            pageLength: 15,
            destroy: true,
            processing: true,
            serverSide: true,
            ordering: false,
            dom: '<tp>',
            ajax: { url: $("#table-feedback-list").data('url') },
            columnDefs: [{'targets': [0], 'className': "px-3"}, {'targets': [1,2], 'className': "text-center"}, {'targets': [0,1,2], 'className': "align-content-center"}],
            columns: [
                { data: 'feedback' },
                { data: 'status' },
                { data: 'action' }
            ]
        });
    }

    toggleIcon(){
        $("#additionalContentParentMenu").find('svg[name="up-down-toggle"]').toggle();
    }

    editFeedback(event){
        let url = event.params["url"];
        const get_data = fetch(url).then(response => {
            if (response.ok) {
                return response.text();
            }
        });
  
        get_data.then((data) => {
            try{
              let result = JSON.parse(data);
              this.alert(result["status"], result["message"]);
            } catch {
              $(".show-dialog").html("");
              $(".show-dialog").html(data);
              $("#addFeedbackLabel").text("Edit Feedback");
              $("#submit-content-btn").val("Update");
              $("#edit-feedback-btn").click();
            }
        });
    }

    clearFeedback(){
        setTimeout(function(){
            document.getElementById("addFeedbackLabel").innerHTML = "Add Feedback"
            document.getElementById("title").value = "";
            document.getElementById("html_content").value = "";
            document.getElementById("update-id").value = "";
            document.getElementById("submit-content-btn").value = "Add"
        }, 500);
    }

    confirmDelete(event){
        let url = event.params["url"];
        let menu_name = event.params["menuName"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "feedback");
        delete_button.setAttribute("data-action", "click->feedback#deleteContent");
        delete_button.setAttribute("data-url", url);
        document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete this "+menu_name+" ?";
        
    }

    deleteContent(){
        let delete_button = document.getElementById("confirm-delete-button");
        let url = delete_button.getAttribute("data-url");
        const delete_additional = fetch(url, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": this.getCsrfToken()
            }
            // body: JSON.stringify({ "id": id }),
        }).then(response => {
            if (response.ok) {
                return response.text();
            }
        });

        delete_additional.then((data) => {
            try{
                let result = JSON.parse(data);
                console.log(result);
                if (result["status"] == "success"){
                    window.location.replace(result["redirect_url"]);
                } else {
                    this.alert(result["status"], result["message"]);
                }
                // this.alert(result["status"], result["message"]);
            } catch(e) {
                console.log(e);
                // $("#close-confirm-delete-dialog").click();
                // $("#show-content-format-data").html("");
                // $("#show-content-format-data").html(data);
            }
        });
    }

    getCsrfToken() {
        return document.querySelector('meta[name="csrf-token"]').content;
    }
}