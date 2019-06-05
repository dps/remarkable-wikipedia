import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true;
    title: qsTr("qtwikipedia")
    width: 1404;
    height: 1872;

    property string edition: "wikipedia_en_simple_all_nopic_2019-05";
    property string homePage: "";
    readonly property string lowerCaseKbd: '<center><font size="+2" face="Noto Emoji"><a href="key-q">q</a> <a href="key-w">w</a> <a href="key-e">e</a> <a href="key-r">r</a> <a href="key-t">t</a> <a href="key-y">y</a> <a href="key-u">u</a> <a href="key-i">i</a> <a href="key-o">o</a> <a href="key-p">p</a> <br/><a href="key-a">a</a> <a href="key-s">s</a> <a href="key-d">d</a> <a href="key-f">f</a> <a href="key-g">g</a> <a href="key-h">h</a> <a href="key-j">j</a> <a href="key-k">k</a> <a href="key-l">l</a> <br/><a href="key-z">z</a> <a href="key-x">x</a> <a href="key-c">c</a> <a href="key-v">v</a> <a href="key-b">b</a> <a href="key-n">n</a> <a href="key-m">m</a> <br/><a href="key-shift">⬆️</a> <a href="key-spc">[=========]</a> <a href="key-del">⬅️</a> </font></center>';
    readonly property string upperCaseKbd: '<center><font size="+2" face="Noto Emoji"><a href="key-Q">Q</a> <a href="key-W">W</a> <a href="key-E">E</a> <a href="key-R">R</a> <a href="key-T">T</a> <a href="key-X">X</a> <a href="key-U">U</a> <a href="key-I">I</a> <a href="key-O">O</a> <a href="key-P">P</a> <br/><a href="key-A">A</a> <a href="key-S">S</a> <a href="key-D">D</a> <a href="key-F">F</a> <a href="key-G">G</a> <a href="key-H">H</a> <a href="key-J">J</a> <a href="key-K">K</a> <a href="key-L">L</a> <br/><a href="key-Z">Z</a> <a href="key-X">X</a> <a href="key-C">C</a> <a href="key-V">V</a> <a href="key-B">B</a> <a href="key-N">N</a> <a href="key-M">M</a> <br/><a href="key-shift">⬆️</a> <a href="key-spc">[=========]</a> <a href="key-del">⬅️</a> </font></center>';
    readonly property int dummy: onLoad();
    property var backStack: [];

    function handleKey(event) {
        if (event.key == 16777234) {
            back();
        } else if (event.key == 16777232) {
            goHome();
        } else if (event.key == 16777236) {
            page();
        }
    }

    function onLoad() {
        if (homePage !== "") {
            return 0;
        }

        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                var reg = '<a href="\/([^\/]*)\/A\/([^\/"]*)">Found<\/a>';
                edition = a.match(reg)[1];
                homePage = a.match(reg)[2];
                goHome();
            }
        }

        doc.open("GET", "http://127.0.0.1:8081/");
        doc.send();
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
        doc.open("GET", "http://127.0.0.1:8081/" + edition + "/A/" + homePage);

        doc.send();
    }

    function showRequestInfo(text) {
        log.y = 100;
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

        query.text = link;
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
                if (edition == "wikipedia" || edition == "1f98c4ecc0d71bc828dc40533d33c426") {
                    a = a.substr(a.indexOf("<a id=\"top\"></a>"));
                } else {
                    a = a.substr(a.indexOf("<div id=\"bodyContent\" class=\"content\">"));
                }
                showRequestInfo(a);
            }
        }
        var url = "http://127.0.0.1:8081/" + edition + "/A/" + encodeURIComponent(page);
        if (page.indexOf(edition) > 0) {
            url = "http://127.0.0.1:8081" + page;
        }

        if ((url.indexOf(".html") < 0) && edition == "wikipedia") {
            url += ".html";
        }

        doc.open("GET", url);
        doc.send();
    }

    function refreshSuggest() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                showRequestInfo(a);
            }
        }

        doc.open("GET", "http://127.0.0.1:8081/" + edition + "/A/" + query.text);
        doc.send();
    }

    Rectangle {
        anchors.fill: parent
        color: "white"

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
            id: qbox;
            width: 1190;
            height: 80;
            x: 10;
            y: 5;
            color: "white";
            border.color: "black";
            border.width: 3;
            radius: 10;
            anchors {margins: 10;}

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
            id: gobox;
            width: 100
            height: 80
            color: "white"
            border.color: "black"
            border.width: 3
            radius: 10;
            y: 5;
            anchors.left: qbox.right;

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
            id: downbox;
            width: 100
            height: 80
            color: "white"
            border.color: "black"
            border.width: 3
            radius: 10
            y: 5; anchors.left: gobox.right;

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
