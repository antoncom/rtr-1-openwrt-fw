
    // Move footer text to the bottom of page if even the page's height is smaller then window size.
    // The function is called under 2 events:
    //      * user changes window size (FireFox, Chrome, Opera was tested)
    //        (see /www/luci-static/qtech/js/script.js)
    //      * RPC responce populate the page with new content
    //        (see /usr/lib/lua/luci/view/themes/qtech/Luci.rpc.override.js.htm)

    window.moveFooterBottom = function() {

        // Because of the function runs several times during the page loading,
        // we need to "reset" it to default value.
        $("#maincontent .container").css("height", "auto");

        var winH = $(window).height()
        var headH = $("header .container").height()
        var viewH = $("#view").height()
        var footH = $("footer.mobile-hide").height()
        var footPad = parseInt($("footer.mobile-hide").css("padding-top")) + parseInt($("footer.mobile-hide").css("padding-bottom"))
        var footMarg = parseInt($("footer.mobile-hide").css("margin-top")) + parseInt($("footer.mobile-hide").css("margin-bottom"))

        // If the page content height is smaller then window height
        if(winH > (viewH + headH + footH + footMarg + footPad + 20)) {
            var contMargBott = parseInt($("#maincontent .container").css("margin-bottom"))
            var contPaddBott = parseInt($("#maincontent .container").css("padding-bottom"))
            $("#maincontent .container").css("height", winH - headH - footPad - footMarg - contMargBott - contPaddBott - 30 + "px")
        // Do nothing if the page height is greater then window size
        } else {
            $("#maincontent .container").css("height", "auto");
        }
    }
