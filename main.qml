import QtQuick 2.6
import QtQuick.Window 2.2
import "."

Window {
    visible: true;
    title: qsTr("qtwikipedia")
    width: 1404;
    height: 1872;

    property bool localZimMode: true;
    property string edition: "fb92b95d083f0cb6a2a17794cf164156"; //"wikipedia_en_simple_all_nopic_2019-05";
    property string homePage: "";
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
        //loadIndexFile();

        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseText;
                var reg = '<a href="\/([^\/]*)\/A\/([^\/"]*)">Found<\/a>';
                var m = a.match(reg);
                if (!m) {
                    localZimMode = false;
                    loadIndexFile();
                    return;
                }
                edition = a.match(reg)[1];
                homePage = a.match(reg)[2];
                goHome();
            }
        }
        doc.onerror = function() {
            localZimMode = false;
            loadIndexFile();
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
        if (localZimMode) {
          doc.open("GET", "http://127.0.0.1:8081/" + edition + "/A/" + homePage);
        } else {
          doc.open("GET", "https://en.wikipedia.org/api/rest_v1/page/html/Main_Page");
        }
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
        if (link.startsWith("./")) {
            link = link.substr(2);
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

    function vkbd(link) {
        var c = link.substring(link.length - 1);
        if (link === "key-spc") {
            c = " ";
        } else if (link === "key-del") {
            query.text = query.text.substring(0, query.text.length - 1);
            c = '';
        }
        query.text += c;
        refreshSuggest();
    }

    function retrieve(page) {
        log.y = 100;
        log.text = "Fetching...";

        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                log.text = "Rendering..."
                var a = doc.responseText;
                if (localZimMode) {
                    if (edition == "wikipedia" || edition == "1f98c4ecc0d71bc828dc40533d33c426") {
                        a = a.substr(a.indexOf("<a id=\"top\"></a>"));
                    } else {
                        a = a.substr(a.indexOf("<div id=\"bodyContent\""));
                    }
                }
                showRequestInfo(a);
            }
        }
        var url;
        if (localZimMode) {
            url = "http://127.0.0.1:8081/" + edition + "/A/" + encodeURIComponent(page);
            if (page.indexOf(edition) > 0) {
                url = "http://127.0.0.1:8081" + page;
            }

            if ((url.indexOf(".html") < 0) && edition == "wikipedia") {
                url += ".html";
            }
        } else {
            url = "https://en.wikipedia.org/api/rest_v1/page/mobile-html/" + encodeURIComponent(page);
        }


        doc.open("GET", url);
        doc.send();
    }

    function refreshSuggest() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                if (localZimMode) {
                    var a = doc.responseText;
                    showRequestInfo(a);
                } else {
                    var json = JSON.parse(doc.responseText);
                    var a = "";
                    for (var i in json.query.pages) {
                        var page = json.query.pages[i];
                        a = a + "<a href='./" + page.title + "'><h2>" + page.title + "</h2><p>" + (page.description || "") + "</p></a>";
                    }
                    showRequestInfo(a);
                }
            }
        }

        if (localZimMode) {
          doc.open("GET", "http://127.0.0.1:8081/" + edition + "/A/" + query.text);
        } else {
          doc.open("GET", "https://en.wikipedia.org/w/api.php?action=query&format=json&generator=prefixsearch&prop=description&redirects=&gpsnamespace=0&gpslimit=6&gpssearch=" + encodeURIComponent(query.text));
        }

        doc.send();
    }

    SwipeArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onSwipe: {
            if(direction == "down") {
                back();
            } else if(direction == "up") {
                page();
            } else {
                return;
            }
        }
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

                TapHandler {
                    onTapped: keyboard.visible = true;
                }

                onFocusChanged: {
                    if (focus) {
                        query.text = "";
                        keyboard.visible = true;
                    } else {
                        keyboard.visible = false;
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

    function getModeText() {
        return localZimMode ? "📱" : "🌎";
    }

    Text {
        id: mode;
        text: "<font size='+1' face='Noto Emoji'>" + getModeText() + "</font>";
        textFormat: Text.RichText;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
    }

    Keyboard {
        id: keyboard;
        visible: false;
        function onChar(ch) {
            vkbd(ch);
        }
    }
}
