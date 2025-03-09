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
        document.getElementById("side-menu-gallery").classList.add("active");

        $("#table-gallery-list").DataTable({
            pagingType: "full_numbers",    
            pageLength: 15,
            destroy: true,
            processing: true,
            serverSide: true,
            ordering: false,
            dom: '<tp>',
            ajax: { url: $("#table-gallery-list").data('url') },
            columnDefs: [{'targets': [0,1, 2], 'className': "text-center"}, {'targets': [0,1,2], 'className': "align-content-center"}],
            columns: [
                { data: 'coverImage' },
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

    uploadPictureGallery(event){
        const file_gallery = event.target.files[0];
        const reader_gallery = new FileReader();
        let num = parseInt(event.params["number"]);

        if (typeof file_gallery == "undefined"){
            document.getElementById("add-pictue-to-gallery-"+num).disabled = true;
        }
    
        reader_gallery.onloadend = () => {
            let default_div_image = document.getElementById("default-preview-image");
            let clone_div = default_div_image.cloneNode(true);
            
            clone_div.id = "div-preview-image-"+num;
            clone_div.classList.add("col-preview-image");
            clone_div.style.display = "block";

            // Edit ID //
            clone_div.querySelector("#preview-image").id = "preview-image-"+num;

            let grid = document.getElementById("gallery-grid");
            grid.insertBefore(clone_div, default_div_image);

            this.setImageAttribute("preview-image-"+num, reader_gallery.result);
            this.createDeletePicture(clone_div, num);
            this.createFileInput(num);

            document.getElementsByClassName("upload-picture-gallery")[0].setAttribute("for", "add-pictue-to-gallery-"+(num+1));
            document.getElementById("add-pictue-to-gallery-"+num).disabled = false;
        }

        if (file_gallery) {
            reader_gallery.readAsDataURL(file_gallery);
        // this.saveAvatar(file, wrapper);
        }
    }

    createFileInput(num){
        let count = num+1;
        let file_input = "<input accept=\".png, .jpg, .jpeg\" data-action=\"change->gallery#uploadPictureGallery\" data-gallery-number-param=\""+count+"\" class=\"upload-picture-btn d-none\" id=\"add-pictue-to-gallery-"+count+"\" type=\"file\" name=\"form_gallery[gallery][picture"+count+"]\"></input>"
        document.getElementsByClassName("div-file-input")[0].insertAdjacentHTML("beforeend", file_input);
    }

    createDeletePicture(div, num){
        let delete_icon = "<span class=\"position-absolute top-0 start-100 translate-middle btn-primary rounded-circle\" data-action=\"click->gallery#deletePicture\" data-gallery-number-param=\""+num+"\" style=\"padding: 2px 5px;\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-x\" viewBox=\"0 0 16 16\"><path d=\"M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708\"/></svg></span>"
        div.querySelector(".div-preview-image").insertAdjacentHTML("beforeend", delete_icon);
    }

    setImageAttribute(elem, src){
        let image = document.getElementById(elem);
        image.src = src;
        image.style.width = "100%";
        // image.style.height = "650px";
    }

    deletePicture(event){
        let number = event.params["number"];
        document.getElementById("div-preview-image-"+number).remove();

        let id = event.params["id"].toString();
        if (id !== "" || id != null){
            let gallery = document.getElementById("arr-gallery-id").value;
            let arr_gallery = gallery.split(",");
            let index = arr_gallery.indexOf(id);
            if (index > -1) {
                arr_gallery.splice(index, 1);
            }
            document.getElementById("arr-gallery-id").value = arr_gallery.join(",");
        }
    }

    editGallery(event){
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
              $("#addGalleryLabel").text("Edit Gallery");
              $("#submit-content-btn").val("Update");
              $("#edit-gallery-btn").click();
            }
        });
    }

    clearGallery(){
        document.getElementById("addGalleryLabel").innerHTML = "Add Gallery"
        document.getElementById("title").value = "";
        document.getElementById("div-content-image").style.display = "none";
        document.getElementById("div-no-image-content").style.display = "block";
        document.getElementById("upload-content-image-btn").value = "";
        document.getElementById("is-update-image").value = "false";
        document.querySelectorAll(".col-preview-image").forEach(el => el.remove());
        document.getElementsByClassName("upload-picture-gallery")[0].setAttribute("for", "add-pictue-to-gallery-1") 
        document.getElementsByClassName("upload-picture-btn")[0].id = "add-pictue-to-gallery-1";
        document.getElementById("arr-gallery-id").value = "";
        document.getElementById("update-id").value = "";
        document.getElementById("submit-content-btn").value = "Add"
    }

    confirmDelete(event){
        let url = event.params["url"];
        let menu_name = event.params["menuName"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "gallery");
        delete_button.setAttribute("data-action", "click->gallery#deleteContent");
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