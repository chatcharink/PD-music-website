import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

export default class extends Controller {

    connect() {
        let menu = document.getElementById("screen-menu");
        let sub_menu = document.getElementById("screen-sub-menu");
        
        if (sub_menu.value == "" || sub_menu.value == null){
            document.getElementById("side-menu-"+menu.value).classList.add("active");
            let parent_menu = document.getElementById(menu.value+"Menu");
            if (parent_menu != null){
                if (!parent_menu.classList.contains("show")){
                    parent_menu.classList.add("show");
                    this.toggleIcon(menu.value);
                }
            }
        }else {
            let parent_menu = document.getElementById(menu.value+"Menu");
            if (!parent_menu.classList.contains("show")){
                parent_menu.classList.add("show");
                this.toggleIcon(menu.value);
            }
            document.getElementById("side-menu-"+sub_menu.value).classList.add("active");
        }
    }

    toggleIcon(parent){
        $("#"+parent+"ParentMenu").find('svg[name="up-down-toggle"]').toggle();
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

    editContent(event){
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
                if (event.params["additional"]){
                    $(".add-additional-content-dialog").html("");
                    $(".add-additional-content-dialog").html(data);
                    $("#addAdditionalContentLabel").text("Edit additional content");
                    $("#submit-additional-content-btn").val("Update");
                    $("#edit-additional-content-btn").click();
                } else {
                    $(".add-content-dialog").html("");
                    $(".add-content-dialog").html(data);
                    $("#addContent1Label").text("Edit content");
                    $("#submit-content-btn").val("Update");
                    $("#edit-content-btn").click();
                }
            }
        });
    }

    clearContent(){
        document.getElementById("addContent1Label").innerHTML = "Add content"
        document.getElementById("title").value = "";
        document.getElementById("url-title").value = "";
        document.getElementById("url").value = "";
        document.getElementById("div-content-image").style.display = "none";
        document.getElementById("div-no-image-content").style.display = "block";
        document.getElementById("upload-content-image-btn").value = "";
        document.getElementById("is-update-image").value = "false";
        document.getElementById("content").value = "";
        document.getElementById("update-id").value = "";
        document.getElementById("submit-content-btn").value = "Add"
        let headers = document.getElementsByClassName("content-header");
        if (headers.length > 1){
            for (let i = headers.length; i > 1; i--){
                headers[i-1].remove();
            }
        }
        this.checkDeleteColumnButton(1);
        document.querySelectorAll(".tr-row").forEach(el => el.remove());
        this.checkDeleteRowButton(0);
        document.getElementById("title-tab").click();
    }

    clearCover(){
        document.getElementById("addCoverLabel").innerHTML = "Add cover"
        document.getElementById("title").value = "";
        document.getElementById("div-content-image").style.display = "none";
        document.getElementById("div-no-image-content").style.display = "block";
        document.getElementById("upload-content-image-btn").value = "";
        document.getElementById("is-update-image").value = "false";
        document.getElementById("category").value = "";
        document.getElementById("update-id").value = "";
        document.getElementById("submit-content-btn").value = "Add"
        document.getElementById("title-tab").click();
    }

    confirmChangeFormat(event){
        let url = event.params["url"];
        let menu = event.params["menu"];
        let confirm_button = document.getElementById("confirm-change-button");
        confirm_button.setAttribute("data-controller", "content");
        confirm_button.setAttribute("data-url", url);
        confirm_button.setAttribute("data-menu", menu);
    }

    changeFormat(){
        let confirm_button = document.getElementById("confirm-change-button");
        let url = confirm_button.getAttribute("data-url");
        let menu = confirm_button.getAttribute("data-menu");
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
                $("#close-confirm-change-dialog").click();
                $(".show-content-format-data").html("");
                $(".show-content-format-data").html(data);
                let side_menu = document.getElementById(menu+"Menu");
                if (side_menu != null){
                    $("#"+menu+"Menu").find(".nav-category-menu").remove();
                }
            //   $("#addContent1Label").text("Edit content");
            //   $("#submit-content-btn").val("Update");
            //   $("#edit-content-btn").click();
            }
        });
    }

    editCover(event){
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
              $(".add-cover-dialog").html("");
              $(".add-cover-dialog").html(data);
              $("#addCoverLabel").text("Edit cover");
              $("#submit-content-btn").val("Update");
              $("#edit-cover-btn").click();
            }
        });
    }

    confirmDeleteDialog(event){
        let url = event.params["url"];
        let id = event.params["id"];
        let content_name = event.params["contentName"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "content");
        delete_button.setAttribute("data-action", "click->content#deleteContent");
        delete_button.setAttribute("data-url", url);
        delete_button.setAttribute("data-id", id);
        document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete this "+content_name+" ?";
    }
  
    deleteContent(){
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
                if (result["status"] == "success"){
                    window.location.replace(result["redirect_url"]);
                } else {
                    this.alert(result["status"], result["message"]);
                }
            } catch {
                $("#close-confirm-delete-dialog").click();
                $("#show-content-format-data").html("");
                $("#show-content-format-data").html(data);
            }
        });
    }

    addColumn(){
        let headers = document.getElementsByClassName("content-header");
        let column_count = headers.length + 1;
        let r_header = document.getElementsByClassName("table-row-header");

        let new_column = '<th class="content-header" style="justify-items: center;"><input value="" class="form-control w-90" id="table-header-'+column_count+'" placeholder="Column '+column_count+'" type="text" name="content[table][header][column'+column_count+']"></th>';
        r_header[0].insertAdjacentHTML("beforeend", new_column);

        let rows = document.getElementsByClassName("tr-row");

        for (let i=0; i < rows.length; i++){
            let content = rows[i].getElementsByClassName("td-content").length;
            for (let j = content; j < column_count; j++){
                let add_row = '<td class="td-content content-row-'+(content+1)+' justify-center"><input value="" class="form-control w-90" type="text" name="content[table][row'+(i+1)+'][column'+(content+1)+']"></td>';
                rows[i].insertAdjacentHTML("beforeend", add_row);
            }
        }

        this.checkDeleteColumnButton(column_count);
    }

    deleteColumn(){
        let headers = document.getElementsByClassName("content-header");
        let column_count = headers.length;

        headers[column_count-1].remove();
        // let rows = document.getElementsByClassName("content-row-"+(column_count));
        // console.log(rows);
        document.querySelectorAll(".content-row-"+(column_count)).forEach(el => el.remove());

        this.checkDeleteColumnButton(column_count-1);
    }

    checkDeleteColumnButton(column_count){
        if (column_count > 1){
            document.getElementById("btn-delete-column").style.display = "inline";
        } else {
            document.getElementById("btn-delete-column").style.display = "none";
        }
    }

    addRow(){
        let headers = document.getElementsByClassName("content-header");

        let rows = document.getElementsByClassName("tr-row").length;
        let row_string = "";
        for (let i = 0; i < headers.length; i++){
            row_string += '<td class="td-content content-row-'+(i+1)+' justify-center"><input value="" class="form-control w-90" type="text" name="content[table][row'+(rows+1)+'][column'+(i+1)+']"></td>';
        }
        let merge_row = "<tr class='tr-row'>"+row_string+"</tr>";
        let tbody = document.getElementById("tbody-content");
        tbody.insertAdjacentHTML("beforeend", merge_row);

        this.checkDeleteRowButton(rows+1);
    }

    deleteRow(){
        let rows = document.getElementsByClassName("tr-row");
        let row_count = rows.length;

        rows[row_count-1].remove();

        this.checkDeleteRowButton(row_count-1);
    }

    checkDeleteRowButton(row_count){
        if (row_count < 1){
            document.getElementById("btn-delete-row").style.display = "none";
        }else {
            document.getElementById("btn-delete-row").style.display = "inline";
        }
    }

    selectAdditional(){
        let selected_additional = document.getElementById("additional_id");
        var text = selected_additional.options[selected_additional.selectedIndex].text;
        console.log(text);
        document.getElementById("additional-title").value = text;
    }

    clearAdditionalContent(){
        document.getElementById("additional-title").value = "";
        document.getElementById("additional_id").value = "";
    }

    getCsrfToken() {
        return document.querySelector('meta[name="csrf-token"]').content;
    }
}