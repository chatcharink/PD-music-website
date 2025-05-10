import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'

export default class extends Controller {
    static targets = [ "password", "confirmPassword" ]

    connect() {
        document.getElementById("side-menu-user").classList.add("active");

        this.table();
    }

    filter(){
        let name = document.getElementById("inputName");
        let status = document.getElementById("selectStatus");
        this.table(name.value, status.value);
    }

    table(name = null, status = null){
        $("#table-user-list").DataTable({
            pagingType: "full_numbers",    
            pageLength: 15,
            destroy: true,
            processing: true,
            serverSide: true,
            ordering: false,
            dom: '<tp>',
            ajax: { 
                url: $("#table-user-list").data('url'),
                contentType: "application/json",
                data: {
                  "user_name": name, "status": status
                }
            },
            columnDefs: [{'targets': [0], 'className': "px-3"}, {'targets': [1,2], 'className': "text-center"}, {'targets': [0,1,2], 'className': "align-content-center"}],
            columns: [
                { data: 'name' },
                { data: 'status' },
                { data: 'action' }
            ]
        });
    }

    validatePassword(){
        let password = this.passwordTargets[0];
        let upper_characters_pattern = /[A-Z]+/;
        let lower_characters_pattern = /[a-z]+/;
        let number_pattern = /[0-9]+/;
        let spacial_characters_pattern = /[\\~\\`\\!\\@\\#\\$\\%\\^\\&\\*\\_\\-\\+\\=\\:\\;\\"\\'\\,\\.\\?]/;
        let password_rule = document.getElementsByClassName("password-rule");
        let is_valid_password = true;
    
        if (password.value.length >= 8){
            this.set_icon_correct(password_rule[0]);
        }else{
            this.set_icon_x(password_rule[0]);
            is_valid_password = false;
        }
    
        if ( upper_characters_pattern.test(password.value) && lower_characters_pattern.test(password.value)){
            this.set_icon_correct(password_rule[1]);
        }else{
            this.set_icon_x(password_rule[1]);
            is_valid_password = false;
        }
    
        if ( number_pattern.test(password.value)){
            this.set_icon_correct(password_rule[2]);
        }else{
            this.set_icon_x(password_rule[2]);
            is_valid_password = false;
        }
    
        if ( spacial_characters_pattern.test(password.value)){
            this.set_icon_correct(password_rule[3]);
        }else{
            this.set_icon_x(password_rule[3]);
            is_valid_password = false;
        }
    
        if (is_valid_password){
          this.valid_value(password);
          document.getElementById("password_valid").value = 1;
          this.enableSetPassword()
        } else {
          document.getElementById("password_valid").value = 0;
          this.enableSetPassword()
        }
    }
    
    enableSetPassword(){
        let is_valid = document.getElementById("password_valid").value;
        let password = document.getElementById("password");
        let confirm_password = document.getElementById("confirm_password");

        if ((password.value == confirm_password.value) && is_valid > 0){
            document.getElementById("btn-set-user-password").disabled = false;
        }else {
            document.getElementById("btn-set-user-password").disabled = true;
        }
    }

    set_icon_correct(elem){
        let icon_x = elem.getElementsByClassName("bi-x-circle-fill");
        icon_x[0].style.display = "none";
        let icon_correct = elem.getElementsByClassName("bi-check-lg");
        icon_correct[0].style.display = "inline";
        elem.style.color = "#3faf49";
    }

    set_icon_x(elem){
        let icon_x = elem.getElementsByClassName("bi-x-circle-fill");
        icon_x[0].style.display = "inline";
        let icon_correct = elem.getElementsByClassName("bi-check-lg");
        icon_correct[0].style.display = "none";
        elem.style.color = "#d31414";
    }

    invalid_value(elem, clear_rule=false){
        elem.style.border = "1px solid #d31414";
        elem.style.background = "#f7caca";
        elem.value = "";
        if (clear_rule){
            let password_rule = document.getElementsByClassName("password-rule");
            for( let i = 0; i < password_rule.length; i++){
                this.set_icon_x(password_rule[i]);
            }
        }
    }

    valid_value(elem){
        elem.style.border = "1px solid #dee2e6";
        elem.style.background = "#fff";
    }

    showPassword(){
        document.getElementById("password").type = "text";
    }

    hidePassword(){
        document.getElementById("password").type = "password";
    }

    showConfirmPassword(){
        document.getElementById("confirm_password").type = "text";
    }

    hideConfirmPassword(){
        document.getElementById("confirm_password").type = "password";
    }

    setPassword(){
        let password = document.getElementById("password");
        document.getElementById("correct_password").value = password.value;
    }

    setDeleteId(event){
        let url = event.params["url"];
        let name = event.params["name"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "user");
        delete_button.setAttribute("data-action", "click->user#deleteUser");
        delete_button.setAttribute("data-url", url);
        document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete user : "+name+" ?";
    }
    
    deleteUser(){
        let delete_button = document.getElementById("confirm-delete-button");
        let url = delete_button.getAttribute("data-url");
        const delete_user = fetch(url, {
            method: 'DELETE',
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": this.getCsrfToken()
            },
            body: JSON.stringify({ "name": name }),
        }).then(response => {
            if (response.ok) {
                return response.text();
            }
        });
    
        delete_user.then((data) => {
            try{
                let result = JSON.parse(data);
                if (result["status"] == "success"){
                    window.location.replace(result["redirect_url"]);
                } else {
                    this.alert(result["status"], result["message"]);
                }
            } catch {
            //   $("#close-confirm-delete-user").click();
            //   this.alert("success", "Delete user : "+name+" successfully");
            //   this.searchUser();
                // $("#div-body-subject").html(data);
            }
        });
    }

    getCsrfToken() {
        return document.querySelector('meta[name="csrf-token"]').content;
    }
}
