import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        
    }

    static targets = [ "embed", "submit" ]

    embedit(e){
        e.preventDefault();
        let embed_txt = document.getElementById("trix-input-embed-text");
        let formData = new FormData()
        formData.append("content", embed_txt.value)
    
        const youtube = fetch("/backend-admin/content/get_embed", {
            method: 'PATCH',
            headers: {
                "X-CSRF-Token": this.getCsrfToken()
            },
            body: formData,
        }).then(response => {
            if (response.ok) {
                return response.text();
            }
        });
    
        youtube.then((data) => {
            let result = JSON.parse(data);
            console.log(result["content"]);
            console.log(result["sgid"]);
            // this.editorElement().(content);
            this.editorController().insertAttachment(result["content"], result["sgid"]);
        });
    }

    editorController(){
        return this.application.getControllerForElementAndIdentifier(this.editorElement(), "trix")
    }

    editorElement(){
        return document.getElementById("content");
        // return document.querySelector(this.editorElementName())
    }

    // editorElementName(){
    //     return `#${this.finderDiv().dataset.editorId}`
    // }

    // finderDiv(){
    //     console.log(this.element);
    //     return this.element.closest('#content')
    // }

    getCsrfToken() {
        return document.querySelector('meta[name="csrf-token"]').content;
    }
}
