import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

export default class extends Controller {

    connect() {
        
    }

    uploadPicture(event) {
      const file = event.target.files[0];
      const reader = new FileReader();

      if (typeof file == "undefined"){
        document.getElementById("upload-banner-btn").disabled = true;
      }
  
      reader.onloadend = () => {
        // this.setImageAttribute("image-banner", reader.result);
        document.getElementById("upload-banner-btn").disabled = false;
        // document.getElementById("div-image-list").style.display = "block";
        this.postImage();
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

    postImage(){
      let form = document.getElementsByClassName("form-upload-banner");
      const upload_banner = fetch(form[0].action, {
        method: 'POST',
        body: new FormData(form[0]),
      }).then(response => {
        if (response.ok) {
          return response.text();
        }
      });

      upload_banner.then((data) => {
        try{
          let result = JSON.parse(data);
          this.alert(result["status"], result["message"]);
        } catch {
          $("#box-content-banner-image").html("");
          $("#box-content-banner-image").html(data);

          this.count_banner();
        }
      });
    }

    confirmDeleteDialog(event){
      let url = event.params["url"];
      let id = event.params["id"];
      let delete_button = document.getElementById("confirm-delete-button");
      delete_button.setAttribute("data-controller", "banner");
      delete_button.setAttribute("data-action", "click->banner#deleteBanner");
      delete_button.setAttribute("data-url", url);
      delete_button.setAttribute("data-id", id);
      document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete this banner ?";
    }

    deleteBanner(){
      let delete_button = document.getElementById("confirm-delete-button");
      let url = delete_button.getAttribute("data-url");
      let id = delete_button.getAttribute("data-id");
      const delete_banner = fetch(url, {
        method: "DELETE",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": this.getCsrfToken()
        },
        body: JSON.stringify({ "id": id }),
      }).then(response => {
        if (response.ok) {
          return response.text();
        }
      });

      delete_banner.then((data) => {
          try{
            let result = JSON.parse(data);
            this.alert(result["status"], result["message"]);
          } catch {
            $("#close-confirm-delete-dialog").click();
            $("#box-content-banner-image").html("");
            $("#box-content-banner-image").html(data);
            this.count_banner();
          }
      });
    }

    count_banner(){
      let has_image = document.getElementsByClassName("row-banner-image");
      if (has_image.length >= 5){
        document.getElementById("upload-banner-btn").disabled = true;
      } else {
        document.getElementById("upload-banner-btn").disabled = false;
      }
    }

    getCsrfToken() {
      return document.querySelector('meta[name="csrf-token"]').content;
    }
}