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
    $("#inputs").replaceWith(`<div id="inputs"> </div>`)
    $(".custom-file-label").text(e.target.files.item(0).name)
    if (e.target.files != undefined) {
      const reader = new FileReader();
      reader.onload = function(e) {
        const headers = e.target.result.split('\n')[0].split(",");
        let form = $("#inputs")
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
    const o1 = options[1]==null ?  options[0] : options[1]
    const o2 = options[2]==null ?  options[0] : options[2]
    const o3 = options[3]==null ?  options[0] : options[4]
    const o4 = options[4]==null ?  options[0] : options[4]
    const o5 = options[5]==null ?  options[0] : options[5]
    form.append(`<div class="form-group">
        <label for="${label}">${label.charAt(0).toUpperCase() + label.slice(1)}</label>
        <select class="form-control" name="${label}" id="${label}">
          <option value="${options[0]}" ${number==0 && "selected"}>${options[0]}</option>
          <option value="${o1}" ${number==1 && "selected"}>${o1}</option>
          <option value="${o2}" ${number==2 && "selected"}>${o2}</option>
          <option value="${o3}" ${number==3 && "selected"}>${o3}</option>
          <option value="${o4}" ${number==4 && "selected"}>${o4}</option>
          <option value="${o5}" ${number==5 && "selected"}>${o5}</option></select>
        </div>`)

  }
});
