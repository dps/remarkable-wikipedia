import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true;
    title: qsTr("qtwikipedia")
    width: 1404;
    height: 1872;

    property string edition: "fb92b95d083f0cb6a2a17794cf164156"; //"wikipedia_en_simple_all_nopic_2019-05";
    property string homePage: "";
    readonly property string lowerCaseKbd: '<center><font size="+2" face="Noto Emoji"><a style="color: black" href="key-q">q</a> <a style="color: black" href="key-w">w</a> <a style="color: black" href="key-e">e</a> <a style="color: black" href="key-r">r</a> <a style="color: black" href="key-t">t</a> <a style="color: black" href="key-y">y</a> <a style="color: black" href="key-u">u</a> <a style="color: black" href="key-i">i</a> <a style="color: black" href="key-o">o</a> <a style="color: black" href="key-p">p</a> <br/><a style="color: black" href="key-a">a</a> <a style="color: black" href="key-s">s</a> <a style="color: black" href="key-d">d</a> <a style="color: black" href="key-f">f</a> <a style="color: black" href="key-g">g</a> <a style="color: black" href="key-h">h</a> <a style="color: black" href="key-j">j</a> <a style="color: black" href="key-k">k</a> <a style="color: black" href="key-l">l</a> <br/><a style="color: black" href="key-z">z</a> <a style="color: black" href="key-x">x</a> <a style="color: black" href="key-c">c</a> <a style="color: black" href="key-v">v</a> <a style="color: black" href="key-b">b</a> <a style="color: black" href="key-n">n</a> <a style="color: black" href="key-m">m</a> <br/><a style="color: black" href="key-shift">⬆️</a> <a style="color: black" href="key-spc">[=========]</a> <a style="color: black" href="key-del">⬅️</a> </font></center>';
    readonly property string upperCaseKbd: '<center><font size="+2" face="Noto Emoji"><a style="color: black" href="key-Q">Q</a> <a style="color: black" href="key-W">W</a> <a style="color: black" href="key-E">E</a> <a style="color: black" href="key-R">R</a> <a style="color: black" href="key-T">T</a> <a style="color: black" href="key-X">X</a> <a style="color: black" href="key-U">U</a> <a style="color: black" href="key-I">I</a> <a style="color: black" href="key-O">O</a> <a style="color: black" href="key-P">P</a> <br/><a style="color: black" href="key-A">A</a> <a style="color: black" href="key-S">S</a> <a style="color: black" href="key-D">D</a> <a style="color: black" href="key-F">F</a> <a style="color: black" href="key-G">G</a> <a style="color: black" href="key-H">H</a> <a style="color: black" href="key-J">J</a> <a style="color: black" href="key-K">K</a> <a style="color: black" href="key-L">L</a> <br/><a style="color: black" href="key-Z">Z</a> <a style="color: black" href="key-X">X</a> <a style="color: black" href="key-C">C</a> <a style="color: black" href="key-V">V</a> <a style="color: black" href="key-B">B</a> <a style="color: black" href="key-N">N</a> <a style="color: black" href="key-M">M</a> <br/><a style="color: black" href="key-shift">⬆️</a> <a style="color: black" href="key-spc">[=========]</a> <a style="color: black" href="key-del">⬅️</a> </font></center>';
    readonly property int dummy: onLoad();
    property var backStack: [];

    function handleKey(event) {
        if (event.key === 16777234) {
            back();
        } else if (event.key === 16777232) {
            goHome();
        } else if (event.key === 16777236) {
            page();
        }
    }

    function onLoad() {
        log.text = "<h1>reMarkable Wikipedia</h1>";

        if (homePage !== "") {
            return 0;
        }
        loadIndexFile();

        // var doc = new XMLHttpRequest();
        // doc.onreadystatechange = function() {
        //     if (doc.readyState == XMLHttpRequest.DONE) {
        //         var a = doc.responseText;
        //         var reg = '<a href="\/([^\/]*)\/A\/([^\/"]*)">Found<\/a>';
        //         edition = a.match(reg)[1];
        //         homePage = a.match(reg)[2];
        //         goHome();
        //     }
        // }

        // doc.open("GET", "http://127.0.0.1:8081/");
        // doc.send();
        return 0;
    }

    function loadIndexFile() {
        log.y = 100;
        log.text = "Fetching..."

        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                showRequestInfo(a);
                log.forceActiveFocus();
            }
        }
        // doc.open("GET", "http://127.0.0.1:8081/" + edition + "/A/" + homePage);
        // https://en.wikipedia.org/api/rest_v1/page/html/Main_Page
        doc.open("GET", "https://en.wikipedia.org/api/rest_v1/page/html/Main_Page");
        doc.send();
    }

    function showRequestInfo(text) {
        log.y = 100;
        const regex = /<a /g;
        text = text.replace(regex, "<a style='color: black' ");
        log.text = text;
    }

    function page() {
        log.y = log.y - 1700;
    }
    function back() {
        log.y = log.y + 1700;
    }

    function goHome() {
        query.text = "Home";
        backStack.push("Home");
        loadIndexFile();
    }

    function navigateBack() {
        console.log(backStack);
        backStack.pop(); // current page
        var page = backStack[backStack.length - 1];
        backStack.pop(); // prev page as it will get immediately added again.
        navigateTo(page);
    }

    function navigateTo(link) {
        if (link === "Home") {
            goHome();
            return;
        }
        var friendlyLink = link;
        var m = link.match('\/([^\/]*)\/A\/([^\/"]*)');
        if (m != null) {
            friendlyLink = m[2];
        }

        query.text = friendlyLink;
        backStack.push(link);
        retrieve(link);
        log.forceActiveFocus();
    }

    function toggleShiftState() {
        if (kbdKeys.text === lowerCaseKbd) {
            kbdKeys.text = upperCaseKbd;
        } else {
            kbdKeys.text = lowerCaseKbd;
        }
    }

    function vkbd(link) {
        var c = link.substring(link.length - 1);
        if (link === "key-spc") {
            c = " ";
        } else if (link === "key-del") {
            query.text = query.text.substring(0, query.text.length - 1);
            c = '';
        } else if (link === "key-shift") {
            toggleShiftState();
            c = '';
        }
        query.text += c;
        if (link !== "key-shift") {
            refreshSuggest();
            if (query.text.length == 1) {
                toggleShiftState();
            }
        }
    }

    function retrieve(page) {
        log.y = 100;
        log.text = "Fetching...";

        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                log.text = "Rendering..."
                var a = doc.responseText;
                // if (edition == "wikipedia" || edition == "1f98c4ecc0d71bc828dc40533d33c426") {
                //     a = a.substr(a.indexOf("<a id=\"top\"></a>"));
                // } else {
                //     a = a.substr(a.indexOf("<div id=\"bodyContent\""));
                // }
                showRequestInfo(a);
            }
        }
        // var url = "http://127.0.0.1:8081/" + edition + "/A/" + encodeURIComponent(page);
        // if (page.indexOf(edition) > 0) {
        //     url = "http://127.0.0.1:8081" + page;
        // }

        // if ((url.indexOf(".html") < 0) && edition == "wikipedia") {
        //     url += ".html";
        // }

        if (page.startsWith("./")) {
            page = page.substr(2);
        }

        var url = "https://en.wikipedia.org/api/rest_v1/page/html/" + encodeURIComponent(page);

        doc.open("GET", url);
        doc.send();
    }

    function refreshSuggest() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var json = JSON.parse(doc.responseText);
                var a = "";
                for (var i in json.query.pages) {
                    var page = json.query.pages[i];
                    a = a + "<a href='./" + page.title + "'><h2>" + page.title + "</h2><p>" + page.description + "</p></a>";
                }
                showRequestInfo(a);
            }
        }

        //doc.open("GET", "http://127.0.0.1:8081/" + edition + "/A/" + query.text);
        doc.open("GET", "https://en.wikipedia.org/w/api.php?action=query&format=json&generator=prefixsearch&prop=description&redirects=&gpsnamespace=0&gpslimit=6&gpssearch=" + encodeURIComponent(query.text));

        doc.send();
    }

    Rectangle {
        anchors.fill: parent
        color: "white"

        MouseArea {
            id: scrollMouseArea
            anchors.fill: parent
            drag.target: log
            drag.minimumY: -log.height + parent.height
            drag.maximumY: 0
            drag.minimumX: 0
            drag.maximumX: 0
            drag.axis: Drag.YAxis
            onReleased: {
                console.log("released")
            }
        }

        Text {
            id: log;
            y: 100;
            anchors { left: parent.left; right: parent.right; }
            anchors.margins: 50;
            text: "";
            textFormat: Text.RichText;
            wrapMode: Text.Wrap;
            onLinkActivated: navigateTo(link);
            focus: true;
            Keys.enabled: true;

            Keys.onReleased: {
                handleKey(event);
            }
        }

    }

    Rectangle {
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        height: 100;
        color: "white"

        Rectangle {
                    id: backbox;
                    width: 100
                    height: 80
                    color: "white"
                    border.color: "black"
                    border.width: 3
                    radius: 10;
                    x: 10;
                    y: 5;

                    Text {
                        id: go;
                        text: "<font size='+1' face='Noto Emoji'>⬅️</font>";
                        textFormat: Text.RichText;
                        anchors {horizontalCenter: parent.horizontalCenter;}
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            if (backStack.length > 1) {
                              navigateBack();
                            }
                        }
                    }
                }
        Rectangle {
            id: qbox;
            width: 1190;
            height: 80;
            y: 5;
            anchors.left: backbox.right;
            color: "white";
            border.color: "black";
            border.width: 3;
            radius: 10;

            TextInput {
                id: query; anchors.top: parent.top;
                text: "Main_Page";
                anchors {horizontalCenter: parent.horizontalCenter;}

                Keys.enabled: true;

                Keys.onReleased: {
                    handleKey(event);
                }

                onFocusChanged: {
                    if (focus) {
                        query.text = "";
                        kbdKeys.text = upperCaseKbd;
                        kbd.visible = true;
                    } else {
                        kbd.visible = false;
                    }
                }

            }

        }

        Rectangle {
            id: downbox;
            width: 100
            height: 80
            color: "white"
            border.color: "black"
            border.width: 3
            radius: 10
            y: 5; anchors.left: qbox.right;

            Text {
                id: sc;
                text: "<font size='+1' face='Noto Emoji'>🏠</font>";
                textFormat: Text.RichText;
                anchors {horizontalCenter: parent.horizontalCenter;}
            }
            MouseArea {
                id: downMouseArea
                anchors.fill: parent
                onClicked: {
                    goHome();
                }
            }
        }

    }



    Rectangle {
        id: bupbox;
        width: 100
        height: 80
        color: "white"
        border.color: "black"
        border.width: 3
        radius: 10
        anchors.right: parent.right;
        anchors.bottom: bdownbox.top;

        Text {
            id: bupbutton;
            text: "<font size='+1' face='Noto Emoji'>⬆️</font>";
            textFormat: Text.RichText;
            anchors {horizontalCenter: parent.horizontalCenter;}
        }
        MouseArea {
            id: bupMouseArea
            anchors.fill: parent
            onClicked: {
                back();
            }
        }
    }
    Rectangle {
        id: bdownbox;
        width: 100
        height: 80
        color: "white"
        border.color: "black"
        border.width: 3
        radius: 10
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        Text {
            id: bsc;
            text: "<font size='+1' face='Noto Emoji'>⬇️</font>";
            textFormat: Text.RichText;
            anchors {horizontalCenter: parent.horizontalCenter;}
        }
        MouseArea {
            id: bdownMouseArea
            anchors.fill: parent
            onClicked: {
                page();
            }
        }
    }

    Rectangle {
        id: kbd;
        visible: false;
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        anchors.right: parent.right;
        height: 320;
        color: "white"

        Text {
            id: kbdKeys
            anchors.centerIn: parent
            text: lowerCaseKbd;
            textFormat: Text.RichText;
            onLinkActivated: vkbd(link);
        }
    }
}
