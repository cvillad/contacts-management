import consumer from "./consumer"

consumer.subscriptions.create("ContactFilesChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $(`#file-status-${data.id}`).text(data.status)
    if (data.status!=="processing"){
      let message, type;
      if (data.status === "finished"){
        message = "File was successfully imported successfully. One or more contacts were correctly imported."
        type = "success"
      }else{
        message = "Failed importing the file. All the contacts were invalid."
        type = "danger"
      }
      $('#container').prepend(`<div class="alert mb-0 text-${type} alert-${type} alert-dismissible fade show bordered" role="alert">
                                  ${message}
                                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                      <span aria-hidden="true">&times;</span>
                                  </button>
                                </div>`)
    }
  }
});
