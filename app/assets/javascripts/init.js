$(document).ready(function() {

  $('.applicant-tabs').tabs();

  // -------------------------------------------------------------------------
  // Converts text areas into trumbowyg editor areas
  // -------------------------------------------------------------------------

  $('.trumbowyg').each(function() {
     $(this).trumbowyg({
     	autoAjustHeight: true,
     	btns: ['viewHTML',
           '|', 'formatting',
           '|', 'bold', 'italic', 'underline',
           '|', 'unorderedList', 'orderedList',
           '|', 'link',
           '|', 'insertImage',
           '|', 'insertHorizontalRule']
     });
  });

});