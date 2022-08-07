jQuery.fn.timer = function( userdefinedoptions ){ 
    var $this = jQuery(this), opt, count = 0; 
 
    opt = jQuery.extend( { 
        // Config 
        'timer' : 300, // 300 second default
        'width' : 400 ,
        'height' : 400 ,
        'fgColor' : "#ED7A53" ,
        'bgColor' : "#232323" 
        }, userdefinedoptions 
    ); 
 
    $this.knob({ 
        'min':0, 
        'max': opt.timer, 
        'readOnly': true, 
        'width': opt.width, 
        'height': opt.height, 
        'fgColor': opt.fgColor, 
        'bgColor': opt.bgColor,                 
        'displayInput' : true, 
        'dynamicDraw': true, 
        'ticks': 2, 
        'thickness': 0.15
    }); 
 
    setInterval(function(){ 
        newVal = ++count; 
        $this.val(newVal).trigger('change'); 
    }, 1000); 
};