import { Controller } from "@hotwired/stimulus"
import Trix from "trix"

export default class extends Controller {
    static get targets() { }

    connect() {
        this.pattern = /^https:\/\/([^\.]+\.)?youtube\.com\/watch\?v=(.*)/

        this.editor = this.element.editor
        this.toolbar = this.element.toolbarElement
        this.buttonGroupFileTools = this.toolbar.querySelector("[data-trix-button-group='file-tools']")
        this.dialogsElement = this.toolbar.querySelector(".trix-dialogs")

        this.addEmbedButton()
        this.addEmbedDialog()
        this.eventListenerForEmbedButton()
    }

    addEmbedButton() {
        const buttonHTML = '<button type="button" class="trix-button" data-trix-action="embed" title="Embed" tabindex="-1">Embed</button>'
        this.buttonGroupFileTools.insertAdjacentHTML("beforeend", buttonHTML);
    }

    addEmbedDialog() {
        const dialogHTML = '<div class="trix-dialog trix-dialog--link" data-trix-dialog="embed" data-trix-dialog-attribute="embed">'+
                            '<div class="trix-dialog__link-fields">'+
                            '<input type="text" name="embed" class="trix-input trix-input--dialog" id="trix-input-embed-text" placeholder="Enter a embed" aria-label="URL" data-trix-input="">'+
                            '<div class="trix-button-group">'+
                            '<input type="button" class="trix-button trix-button--dialog" value="Add" data-controller="youtube" data-action="click->youtube#embedit">'+
                            '</div>'+
                            '</div>'+
                            '</div>';
        this.dialogsElement.insertAdjacentHTML("beforeend", dialogHTML)
    }

    showembed(event){
        const dialog = this.toolbar.querySelector('[data-trix-dialog="embed"]')
        const embedInput = this.dialogsElement.querySelector('[name="embed"]')
        if (event.target.classList.contains("trix-active")) {
          event.target.classList.remove("trix-active");
          dialog.classList.remove("trix-active");
          delete dialog.dataset.trixActive;
          embedInput.setAttribute("disabled", "disabled");
        } else {
          event.target.classList.add("trix-active");
          dialog.classList.add("trix-active");
          dialog.dataset.trixActive = "";
          embedInput.removeAttribute("disabled");
          embedInput.focus();
        }
    }

    eventListenerForEmbedButton() {
        // console.log(this.toolbar);
        this.toolbar.querySelector('[data-trix-action="embed"]').addEventListener("click", e => {
          this.showembed(e)
        })
    }

    insertAttachment(content, sgid){
        // console.log(content);
        const attachment = new Trix.Attachment({content, sgid});
        console.log(attachment);
        this.element.editor.insertAttachment(attachment);
        this.toolbar.querySelector('[data-trix-action="embed"]').click();
    }
}