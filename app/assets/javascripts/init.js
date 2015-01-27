$(document).ready(function() {

  // -------------------------------------------------------------------------
  // Initiate Tabs
  // -------------------------------------------------------------------------
  $('.applicant-tabs').tabs();
  $('.jmi-tabs').tabs();

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

   $('.trumbowyg-minimal').each(function() {
     $(this).trumbowyg({
      autoAjustHeight: true,
      btns: [ 'bold', 'italic', 'underline',
           '|', 'unorderedList', 'orderedList',
           '|', 'link']
     });
  });

  // -------------------------------------------------------------------------
  // Activate WOW JS
  // -------------------------------------------------------------------------
  new WOW().init();

  // -------------------------------------------------------------------------
  // Colour Thief - stealing colours since 2014
  // -------------------------------------------------------------------------
  $('.get-colours').on('click', function(event) {
    var colours = colorsForImage($('.company-logo'));
    $('body').css('background-color', colours['hex']['color']);

  });

  var colorsForImage = function($image) {
    var colorThief = new ColorThief();
    var image = $image[0];
    var color = colorThief.getColor(image);
    var palette = colorThief.getPalette(image);
    var colorThiefOutput = {
      rgb: {
        color: color,
        palette: palette
      },
      hex: {
        color: rgbToHex(color[0], color[1], color[2]),
        palette: palette.map(function(item){ return rgbToHex(item[0], item[1], item[2]); })
      }
    };
    return colorThiefOutput;
  };

  function componentToHex(c) {
      var hex = c.toString(16);
      return hex.length == 1 ? "0" + hex : hex;
  }

  function rgbToHex(r, g, b) {
      return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
  }

});