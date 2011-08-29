function toggler_setup(jq) {
    jq = jq || document;
    $('.toggler', jq).click(function(e) {
        e.preventDefault();
        var target = this.rel ? $(this.rel) : $(this).next();
        target.slideToggle();
    });
}



$(document).ready(function() {
    toggler_setup();    
});