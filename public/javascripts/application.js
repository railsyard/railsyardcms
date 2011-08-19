// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Removes a snippet directly from the frontend when frontend controls are enabled
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

$(document).ready(function() {
    // Provides sorting of snippets, submitting the list of snippets present in every area
    $('.snippets').sortable({
        items:'.drag_item',
        forceHelperSize:true,
        placeholder: 'dashed_placeholder',        
        forcePlaceholderSize:true,
        connectWith: '.drop_target',
        handle: '.title',
        start: function(event, ui) {
          $('.drop_target').addClass('dragging');
        },
        stop: function(event, ui){
          $('.drop_target').removeClass('dragging');
            var sortorder={};
            $('.drop_target').each(function(){
                var itemorder=$(this).sortable('toArray');
                var targetId=$(this).attr('id');
                sortorder[targetId] = itemorder.toString();
            });
            $.ajax({
                type: 'put',
                url: '/admin/pages/4/snippets/sort',
                data: ({'areas':sortorder}),
                error: function(data, textStatus, jqXHR) {
                  alert(data.statusText + ' ('+data.status+')');
                  location.reload();
                }
            });
        } 
    });
});