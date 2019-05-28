import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true;
    title: qsTr("qtwikipedia")
    width: 1404;
    height: 1872;

    property string wiki: "";
    property int dummy: onLoad();

    function handleKey(event) {
        if (event.key == 16777234) {
            // Left key, no action right now.
        } else if (event.key == 16777232) {
            goHome();
        } else if (event.key == 16777236) {
            page();
        }
    }

    function onLoad() {
        goHome();
        return 0;
    }

    function showRequestInfo(text) {
        log.y = 100;
        log.text = text;
        wiki = text;
    }

    function page() {
        log.text = ""
        log.y = log.y - 800;
        log.text = wiki;
    }

    function goHome() {
        navigateTo("Main_Page");
        log.forceActiveFocus();
    }

    function navigateTo(link) {
        query.text = link;
        retrieve(link);
        log.forceActiveFocus();
    }

    function vkbd(link) {
        var c = link.substring(link.length - 1);
        if (link == "key-spc") {
            c = " ";
        } else if (link == "key-del") {
            query.text = "";
            return;
        }
        query.text += c;
        refreshSuggest();
    }

    function retrieve(page) {
        log.y = 100;
        log.text = "Fetching..."
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                a = a.substr(a.indexOf("<div id=\"bodyContent\" class=\"content\">"));
                showRequestInfo(a);
            }
        }

        doc.open("GET", "http://127.0.0.1:8000/wikipedia_en_simple_all_nopic_2019-05/A/" + encodeURIComponent(page));
        doc.send();
    }

    function random() {
        log.y = 100;
        query.text = "random...";
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                a = a.substr(a.indexOf("<div id=\"bodyContent\" class=\"content\">"));
                showRequestInfo(a);
                log.forceActiveFocus();
                query.text = doc.responseText.match("<title>([^<]*)</title>")[1];
            }
        }

        doc.open("GET", "http://127.0.0.1:8000/random?content=wikipedia_en_simple_all_nopic_2019-05");
        doc.send();
    }

    function refreshSuggest() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                var results = eval(a);
                var suggest = "<font size='+2'>";
                for (var i in results) {
                    suggest += "<a href='" + results[i].value + "'>" + results[i].label + "</a><br/>";
                }
                suggest += "</font>";

                showRequestInfo(suggest);
                // Note, focus is not moved out of input box.
            }
        }

        doc.open("GET", "http://127.0.0.1:8000/suggest?content=wikipedia_en_simple_all_nopic_2019-05&term=" + query.text);
        doc.send();
    }

    Rectangle {
        anchors.fill: parent
        color: "white"

        Text {
            id: log;
            height: 1772;
            y: 100;
            anchors { left: parent.left; right: parent.right; }
            anchors.margins: 50;
            text: "";
            textFormat: Text.RichText;
            wrapMode: Text.Wrap;
            onLinkActivated: navigateTo(link);
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
                text: "<font size='+1' face='Noto Emoji'>🔎</font>";
                textFormat: Text.RichText;
                anchors {horizontalCenter: parent.horizontalCenter;}
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    retrieve(query.text);
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
                text: "<font size='+1' face='Noto Emoji'>🔀</font>";
                textFormat: Text.RichText;
                anchors {horizontalCenter: parent.horizontalCenter;}
            }
            MouseArea {
                id: downMouseArea
                anchors.fill: parent
                onClicked: {
                    random();
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
        height: 300;
        color: "white"



        Text {
            anchors.centerIn: parent
            text: '<center><font size="+3" face="Monospace"><a href="key-q">q</a> <a href="key-w">w</a> <a href="key-e">e</a> <a href="key-r">r</a> <a href="key-t">t</a> <a href="key-y">y</a> <a href="key-u">u</a> <a href="key-i">i</a> <a href="key-o">o</a> <a href="key-p">p</a> <br/><a href="key-a">a</a> <a href="key-s">s</a> <a href="key-d">d</a> <a href="key-f">f</a> <a href="key-g">g</a> <a href="key-h">h</a> <a href="key-j">j</a> <a href="key-k">k</a> <a href="key-l">l</a> <br/><a href="key-z">z</a> <a href="key-x">x</a> <a href="key-c">c</a> <a href="key-v">v</a> <a href="key-b">b</a> <a href="key-n">n</a> <a href="key-m">m</a> <a href="key-spc">spc</a> <a href="key-del">del</a> </font></center>'
            textFormat: Text.RichText;
            onLinkActivated: vkbd(link);

        }
    }
}
