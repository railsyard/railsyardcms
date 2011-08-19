// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function removeSnip(snip_id, url) {
  jQuery.ajax({
    url: url,
    type: 'delete',
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    cache: false,
    success: function(data, textStatus, jqXHR) {
      $('#snippet-'+snip_id).remove();
    },
    error: function(data, textStatus, jqXHR) {
      result = jQuery.parseJSON(data.responseText);
      alert(result.message);
    }
  });
}