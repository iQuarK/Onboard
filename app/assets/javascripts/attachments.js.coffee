# Used Jquery File Upload - http://blueimp.github.io/jQuery-File-Upload/
# Ryan Bates screencast - http://railscasts.com/episodes/381-jquery-file-upload?view=asciicast

jQuery ->

  # $('#new_application').fileupload
  #   dataType: 'script'
  #   maxNumberOfFiles: 10
  #   # dropZone: $('#application_attachments')
  #   add: (e, data) ->
  #     types = /(\.|\/)(pdf|doc|docx|odt|fodt|csv|xls|xlsx|ods|fods|jpg|jpeg|png)$/i
  #     file = data.files[0]
  #     # Only submit the file for upload if its one of the allowed flietypes
  #     if types.test(file.type) || types.test(file.name)
  #       data.context = $(tmpl("template-upload", data.files[0]))
  #       # "This" refers to the file input field
  #       $(this).closest('form').append(data.context)
  #       data.submit()
  #     else
  #       alert("#{file.name} is not a pdf, word document, spreadsheet or image file")
  #   progress: (e, data) ->
  #     # Displaying the progress bar
  #     if data.context
  #       progress = parseInt(data.loaded / data.total * 100, 10)
  #       data.context.find('.bar').css('width', progress + '%')