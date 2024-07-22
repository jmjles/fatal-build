.pragma library

/* retrieveing size of panel */
function getPanelSize( screen_width, screen_height ) {
    var k_16_9 = 16/9,
        k_4_3 = 4/3,
        k_cur = screen_width / screen_height,
        panel_width = screen_width,
        panel_height_16_9 = Math.round(screen_width * 0.097),
        panel_height_4_3 = Math.round(screen_width * 0.099),
        panel_height;

    if(k_cur <= k_4_3) {
        panel_height = panel_height_4_3;
    }
    else if(k_cur < k_16_9) {
        if(Math.abs(k_cur - k_4_3) >= Math.abs(k_16_9 - k_cur))
            panel_height = panel_height_16_9;
        else
            panel_height = panel_height_4_3;
    }
    else {
        panel_height = panel_height_16_9;
    }

    // adjust size on small screens
    var k = 1;
    if(screen_width <= 1280)
        k = 1.26;
    panel_height = Math.round(panel_height * k);
    return Qt.size(panel_width, panel_height);
}

/* retrieveing size of playlist */
function getPlaylistSize( screen_width ) {
    var width,
        height,
        k = 1;

    if(screen_width <= 1280)
        k = 1.26;

    height = Math.round(screen_width * 0.349 * k);
    width = Math.round(height * 1.493);

    return Qt.size(width, height);
}

/* retrieveing path to the pngs */
function getImagesPath( screen_width ) {
    var width;
    if(screen_width >= 1920)
        width = "1920";
    else if(screen_width >= 1600)
        width = "1600";
    else if(screen_width >= 1280)
        width = "1280";
    else if(screen_width >= 1024)
        width = "1024";
    else
        width = "800";

    return width + "/";
}

/* seconds value to formated string xx:xx:xx */
function secondsAsString( seconds ) {
    var h = Math.floor(seconds / 3600);
    var m = Math.floor(seconds % 3600 / 60);
    var s = Math.floor(seconds % 3600 % 60);
    return ((h>0) ? ((h<10) ? "0"+h : h) : "00") + ":" +
           ((m>0) ? ((m<10) ? "0"+m : m) : "00") + ":" +
           ((s>0) ? ((s<10) ? "0"+s : s) : "00");
}

/* formated string xx:xx:xx to seconds */
function stringAsSeconds( string ) {
    var hsm = string.split(":");
    return 3600*parseInt(hsm[0],10) + 60*parseInt(hsm[1],10) + parseInt(hsm[2],10);
}
