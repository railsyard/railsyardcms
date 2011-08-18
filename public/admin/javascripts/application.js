// Railsyard CMS admin panel main js file
$(function() {
  
  // Accordion for main sidebar navigation
  $( "ul#accordion" ).accordion({
      collapsible: false,
      active:true,
      header: 'li a.top_level',
      autoHeight:false,
      icons:false
  });
  
  // Accordion dropdown
  $( "ul.dropdown" ).accordion({
      collapsible: true,
      active:false,
      header: 'li a.has_slide', // this is the element that will be clicked to activate the accordion 
      autoHeight:false,
      event: 'mousedown',
      icons:false
  });
     
  // Open and close content boxes
  $("a.toggle").click(function(){
      $(this).toggleClass("toggle_closed").next().slideToggle("slow");
      return false; //Prevent the browser jump to the link anchor
  });
  
  // Datepicker config
  $( ".datepicker" ).datepicker({ dateFormat: 'd M yy' }); // http://docs.jquery.com/UI/Datepicker/formatDate
  
  // Uniform config http://pixelmatrixdesign.com/uniform
  $( "select, input:checkbox, input:radio, input:file").uniform();
  
  // Tipsy config http://onehackoranother.com/projects/jquery/tipsy
  $('[title]').tipsy({
      fade: true,     // fade tooltips in/out?
      fallback: '',    // fallback text to use when no tooltip text
      gravity: 's',    // gravity
      opacity: 1,    // opacity of tooltip
      title: 'title',  // attribute/callback containing tooltip text
      trigger: 'hover' // how tooltip is triggered - hover | focus | manual        
  });
  
  $('input[title]').tipsy({
    trigger: 'focus',  
    offset:'5',
    gravity: 'w'
  });
  
  // DataTables config http://www.datatables.net
  var tableObj = $('.datatable').dataTable( {
    "bJQueryUI": true,
    "sScrollX": "",
    "bSortClasses": false,
    "aaSorting": [[0,'asc']],
    "bAutoWidth": true,
    "bInfo": true,
    "sScrollY": "100%",    
    "sScrollX": "100%",
    "bScrollCollapse": true,
    "sPaginationType": "full_numbers",
    "bRetrieve": true,
    "aLengthMenu": [[5, 10, 30, -1], [5, 10, 30, "All"]],
    "iDisplayLength": 10
  });
  
  $(window).bind('resize', function () {
          tableObj.fnAdjustColumnSizing();
  });
      
  // static tables alternating rows
  $('table.static tr:even').addClass("even")
  
  //Back to top link
  $().UItoTop({ easingType: 'easeOutQuart' });
  
});