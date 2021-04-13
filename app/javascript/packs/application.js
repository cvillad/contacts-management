// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).on("turbolinks:load", function() {
  $('#file').on("change", function(e) {
    if (e.target.files != undefined) {
      const reader = new FileReader();
      
      reader.onload = function(e) {
        const headers = e.target.result.split('\n')[0].split(",");
        console.log(headers[0])
        $('#text').text(headers);

        let form = $("#contact-file-form");
        append_select(form, "name", 0, headers)
        append_select(form, "email", 1, headers)
        append_select(form, "birth_date", 2, headers)
        append_select(form, "phone", 3, headers)
        append_select(form, "address", 4, headers)
        append_select(form, "card_number", 5, headers)
        form.append(`<input type="submit" name="commit" value="Upload" class="btn btn-success" data-disable-with="Upload" />`)
      };

      reader.readAsText(e.target.files.item(0));
    }
    return false;
  });

  function append_select(form, label, number, options){
    form.append(`<div>
        <label for="${label}">${label.charAt(0).toUpperCase() + label.slice(1)}</label>
        <select name="${label}" id="${label}">
          <option value="${options[0]}" ${number==0 && "selected"}>${options[0]}</option>
          <option value="${options[1]}" ${number==1 && "selected"}>${options[1]}</option>
          <option value="${options[2]}" ${number==2 && "selected"}>${options[2]}</option>
          <option value="${options[3]}" ${number==3 && "selected"}>${options[3]}</option>
          <option value="${options[4]}" ${number==4 && "selected"}>${options[4]}</option>
          <option value="${options[5]}" ${number==5 && "selected"}>${options[5]}</option></select>
        </div>`)

  }
});
