// Main.js

function displayDateAsHHMMSS() {
    var d = new Date();
    var s = d.getSeconds ();
    var sep = s % 2 == 0 ? " " : ":"; 
    return (("0" + d.getHours()).slice(-2) + ":" +
    ("0" + d.getMinutes()).slice(-2) + sep +
    ("0" + s).slice(-2));
}

