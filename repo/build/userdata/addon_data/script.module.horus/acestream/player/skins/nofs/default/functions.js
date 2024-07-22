.pragma library

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
