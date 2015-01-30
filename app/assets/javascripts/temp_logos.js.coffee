jQuery ->

  $('#company_logo_form').fileupload
    dataType: 'script'
    maxNumberOfFiles: 1
    # dropZone: $('#application_attachments')
    add: (e, data) ->
      types = /(\.|\/)(jpg|jpeg|png)$/i
      file = data.files[0]
      # Only submit the file for upload if its one of the allowed flietypes
      if types.test(file.type) || types.test(file.name)
        data.submit()
      else
        alert("#{file.name} is not an image file")