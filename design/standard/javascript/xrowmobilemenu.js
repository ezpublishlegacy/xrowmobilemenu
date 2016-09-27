(function ( $ ) {
    jQuery.fn.xrowmobilemenu = function( options ) {
        return this.each(function() {
            var toggle = $(this);
            var settings = $.extend({
                current_node_id: false,
                root_node_id: false,
                focus_current_node: false,
                siteaccessname: false
                }, options );
            if ( toggle.is("[data-current_node]") )
            {
                settings.current_node_id = toggle.data("current_node");
            }
            if ( toggle.is("[data-root_node]") )
            {
                settings.root_node_id = toggle.data("root_node");
            }
            if ( toggle.is("[data-focus_current_node]") )
            {
                settings.focus_current_node = toggle.data("focus_current_node");
            }
            if ( toggle.is("[data-siteaccessname]") )
            {
                settings.siteaccessname = toggle.data("siteaccessname");
            }
            mobileMenuGetChildren(false, settings.current_node_id, settings.root_node_id, settings.focus_current_node, settings.siteaccessname);
            $("body").append('<div class="xrow-mobile-menu-layer"></div>');
            toggle.on('click', function(){
                $(".xrow-mobile-menu-layer").fadeIn("slow");
                $(".xrow-mobile-menu").animate({left: "0px"}, 200);
                //window.scrollTo(0, 0);
                /*disable background overscroll*/
                $(document).bind('touchmove', function(e){
                    if(!$('.xrow-mobile-menu').has($(e.target)).length)
                        e.preventDefault();
                });
                $("body").css({
                    overflow: "hidden",
                    position: "fixed",
                    width: "100%"
                });
            });

            $(".xrow-mobile-menu-layer").on('click', function(){
                $(this).fadeOut("slow");
                $(".xrow-mobile-menu").animate({
                    left: "-" + $(".xrow-mobile-menu").outerWidth() + "px"
                    }, 200);
                $(document).unbind('touchmove');
                $("body").css({
                    overflow: "auto",
                    position: "",
                    width:""
                });
            });
        });
    }
}( jQuery ));

//this block is for backwards compatibility
$(document).ready(function(){
    if( $(".toggle_xrow_mobile_menu").length )
    {
        $(".toggle_xrow_mobile_menu").xrowmobilemenu();
    }
});
$( window ).resize(function() {
    if( $(".xrow-mobile-menu").length )
    {
        var count_active = $(".xrow-mobile-menu .active").length;
        $(".xrow-mobile-menu ul:first").css({ left: parseInt( -1 * count_active * $(".xrow-mobile-menu").outerWidth() ) + "px" });
        if( $(".xrow-mobile-menu").css("left") != "0px" )
        {
            $(".xrow-mobile-menu").css({left: "-" + $(".xrow-mobile-menu").outerWidth() + "px" });
        }
    }
});
function mobileMenuGetChildren(object, current_node_id, root_node_id, focus_current_node, siteaccessname)
{
    if (siteaccessname == false) {
        siteaccessname = "";
    }
    if (object == false)
    {
        var menu_url = false;
    }
    else
    {
        var menu_url = $(object).data("nodeid");
    }
    $(".xrow-mobile-menu span").click(function(){
        $(".xrow-mobile-menu").animate({ scrollTop: 0 }, 0);
    });

    if( $(object).find("ul").length == false )
    {
         $.ajax({
             url: "//" + siteaccessname + '/xrowmobilemenu/view/' + menu_url + "/" + current_node_id + "/" + root_node_id + "/" + focus_current_node + "/",
             type: "GET",
             crossDomain: false,
             success: function (data) {
                 if (object == false)
                 {
                     $("body").append(data);
                     $(".xrow-mobile-menu").find(".children").each(function(){
                         $(this).one("mouseenter", function(){
                             mobileMenuGetChildren($(this), current_node_id, root_node_id, false, siteaccessname);
                         });
                     });
                 }
                 else
                 {
                     $(object).append(data);
                     $(object).find(".children").each(function(){
                         $(this).one("mouseenter", function(){
                             mobileMenuGetChildren($(this), current_node_id, root_node_id, false, siteaccessname);
                         });
                     });
                 }
                 if( focus_current_node == true && $(".xrow-mobile-menu .active").length )
                 {
                     var count_active = $(".xrow-mobile-menu .active").length;
                     //window.console.log(count_active + " count active");
                     $(".xrow-mobile-menu > ul").css({
                         left: parseInt( -1 * count_active * $(".xrow-mobile-menu").outerWidth() ) + "px"
                     });
                 }
                 $(".closemenu").on('click', function(){
                     $(".xrow-mobile-menu-layer").fadeOut("slow");
                     $(".xrow-mobile-menu").animate({
                         left: "-" + $(".xrow-mobile-menu").outerWidth() + "px"
                         }, 200);
                     $(document).unbind('touchmove');
                     $("body").css({
                         overflow: "auto",
                         position: "",
                         width: ""
                     });
                 });
                 $(".xrow-mobile-menu span").click(function(){
                     var clicked = $(this);
                     $(".xrow-mobile-menu > ul").animate({
                         left: parseInt( -1 * $(clicked).data("depth") * $(".xrow-mobile-menu").outerWidth() ) + "px"
                     }, 100, function(){
                         if( $(clicked).hasClass("back") )
                         {
                             $(clicked).closest("li.depth-" + $(clicked).data("depth")).removeClass("active");
                         }
                     });
                     if( $(clicked).hasClass("back") == false )
                     {
                         $(clicked).closest("li").first().addClass("active");
                     }
                 });
             },
             error: function (xhr, status) {
                 //console.log("error menu");
             }
         });
    }
    else
    {
        $(".xrow-mobile-menu span").click(function(){
            var depth = $(this).data("depth");
            $(".xrow-mobile-menu > ul").animate({
                left: parseInt( -1 * depth * $(".xrow-mobile-menu").outerWidth() ) + "px",
            }, 100);
        });
    }
}