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
        document.getElementById("side-menu-school").classList.add("active");

        $("#table-school-list").DataTable({
            pagingType: "full_numbers",    
            pageLength: 15,
            destroy: true,
            processing: true,
            serverSide: true,
            ordering: false,
            dom: '<tp>',
            ajax: { url: $("#table-school-list").data('url') },
            columnDefs: [{'targets': [0,3], 'className': "text-center"}, {'targets': [0,1,2,3], 'className': "align-content-center"}],
            columns: [
                { data: 'image' },
                { data: 'school' },
                { data: 'status' },
                { data: 'action' }
            ]
        });
    }

    toggleIcon(){
        $("#additionalContentParentMenu").find('svg[name="up-down-toggle"]').toggle();
    }

    uploadPicture(event) {
      const file = event.target.files[0];
      const reader = new FileReader();

      if (typeof file == "undefined"){
        document.getElementById("upload-content-image-btn").disabled = true;
      }
  
      reader.onloadend = () => {
        this.setImageAttribute("content-image", reader.result);
        document.getElementById("upload-content-image-btn").disabled = false;
        document.getElementById("div-content-image").style.display = "block";
        if (document.getElementById("div-no-image-content") !== null){
            document.getElementById("div-no-image-content").style.display = "none";
        }else{
            document.getElementById("div-image-content").style.display = "none";
        }
        document.getElementById("is-update-image").value = "true";
      };

      if (file) {
          reader.readAsDataURL(file);
      // this.saveAvatar(file, wrapper);
      }
    }

    setImageAttribute(elem, src){
        let image = document.getElementById(elem);
        image.src = src;
        image.style.width = "100%";
        // image.style.height = "650px";
    }

    editSchool(event){
        let url = event.params["url"];
        console.log(url);
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
              $("#addSchoolLabel").text("Edit School");
              $("#submit-content-btn").val("Update");
              $("#edit-school-btn").click();
            }
        });
    }

    clearSchool(){
        document.getElementById("addSchoolLabel").innerHTML = "Add School"
        document.getElementById("title").value = "";
        document.getElementById("div-content-image").style.display = "none";
        document.getElementById("div-no-image-content").style.display = "block";
        document.getElementById("upload-content-image-btn").value = "";
        document.getElementById("is-update-image").value = "false";
        document.getElementById("url").value = "";
        document.getElementById("update-id").value = "";
        document.getElementById("submit-content-btn").value = "Add"
    }

    confirmDelete(event){
        let url = event.params["url"];
        let menu_name = event.params["menuName"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "school");
        delete_button.setAttribute("data-action", "click->school#deleteContent");
        delete_button.setAttribute("data-url", url);
        document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete this "+menu_name+" ?";
        
    }

    deleteContent(){
        let delete_button = document.getElementById("confirm-delete-button");
        let url = delete_button.getAttribute("data-url");
        const delete_banner = fetch(url, {
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

        delete_banner.then((data) => {
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