import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'

export default class extends Controller {
    connect() {
        // let menu = document.getElementById("screen-menu").value;
        document.getElementById("side-menu-navigator").classList.add("active");
    
        this.table();
    }

    filter(){
        let name = document.getElementById("inputMenu");
        let status = document.getElementById("selectStatus");
        this.table(name.value, status.value);
    }

    table(name = null, status = null){
        $("#table-menu-list").DataTable({
            pagingType: "full_numbers",
            pageLength: 15,
            destroy: true,
            processing: true,
            serverSide: true,
            ordering: false,
            dom: '<tp>',
            ajax: { 
                url: $("#table-menu-list").data('url'),
                contentType: "application/json",
                data: {
                  "name": name, "status": status
                },
                error: function(e){
                    console.log(e);
                }
            },
            columnDefs: [{'targets': [1,2,3,4], 'className': "text-center"}, {'targets': [0,1,2,3,4], 'className': "align-content-center"}, {'targets': [0,1,2,3,4], 'className': "justify-center"}],
            columns: [
                { data: 'menuName' },
                { data: 'header' },
                { data: 'footer' },
                { data: 'status' },
                { data: 'action' }
            ]
        });
    }

    checkTag(){
        let menu_name = document.getElementById("menu_name");
        let tag = document.getElementById("menu_tag");
        let tag_pattern = /[a-zA-Z]+/
        let valid_name = false;
        let valid_tag = false;

        if (menu_name.value == ""){
            menu_name.style.border = "1px solid #d31414";
            menu_name.style.background = "#f7caca";
            menu_name.value = "";
        } else {
            menu_name.style.border = "1px solid #dee2e6";
            menu_name.style.background = "#fff";
            valid_name = true;
        }

        if (tag_pattern.test(tag.value)){
            tag.style.border = "1px solid #dee2e6";
            tag.style.background = "#fff";
            valid_tag = true
        } else {
            tag.style.border = "1px solid #d31414";
            tag.style.background = "#f7caca";
            tag.value = "";
        }

        if (valid_name && valid_tag){
            document.getElementById("submit-content-btn2").click();
        }
    }

    editMenu(event){
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
              $(".show-dialog-menu").html("");
              $(".show-dialog-menu").html(data);
              $("#addMenuLabel").text("Edit Menu");
              $("#submit-content-btn").text("Update");
              $("#edit-menu-btn").click();
            }
        });
    }

    clearMenu(){
        document.getElementById("addMenuLabel").innerHTML = "Add Menu"
        let name = document.getElementById("menu_name")
        name.style.border = "1px solid #dee2e6";
        name.style.background = "#fff";
        name.value = "";
        let tag = document.getElementById("menu_tag");
        tag.style.border = "1px solid #dee2e6";
        tag.style.background = "#fff";
        tag.value = "";
        tag.removeAttribute("disabled");
        document.getElementById("menu_icon").value = "";
        document.getElementById("update-id").value = "";
        document.getElementById("submit-content-btn").innerHTML = "Add"
        document.getElementById("headerCheck").checked = false;
        document.getElementById("footerCheck").checked = false;
    }

    confirmDelete(event){
        let url = event.params["url"];
        let menu_name = event.params["menuName"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "menu");
        delete_button.setAttribute("data-action", "click->menu#deleteMenu");
        delete_button.setAttribute("data-url", url);
        document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete menu : "+menu_name+" ?";
        
    }

    deleteMenu(){
        let delete_button = document.getElementById("confirm-delete-button");
        let url = delete_button.getAttribute("data-url");
        const delete_menu = fetch(url, {
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

        delete_menu.then((data) => {
            try{
                let result = JSON.parse(data);
                if (result["status"] == "success"){
                    window.location.replace(result["redirect_url"]);
                } else {
                    this.alert(result["status"], result["message"]);
                }
                // this.alert(result["status"], result["message"]);
            } catch {
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