import QtQuick 2.0
import "../js/Main.js" as MainJS

Rectangle {
    id: canvas
    width: 1404
    height: 1872

    Behavior on y {
        NumberAnimation {
            property:"y"
            to:0
            duration:1000
        }
    }

    Text {
        id: heading
        anchors.left:parent.left
        anchors.right:parent.right
        text: " <font size=8> draft</font> launcher"
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 80
        font.family:"Noto Serif"
        font.italic:true
    }

    Text {
        id: credit
        anchors.right:parent.right
        anchors.bottom:parent.bottom
        anchors.margins: {bottom:10}
        text: qsTr("draft v0.2 created by @dixonary_")
        font.pixelSize: 30
        font.family:"Noto Serif"
        font.italic:true
    }

    Text {
        id: optionsHeading
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.margins:50
        horizontalAlignment:Text.AlignLeft
        font.pixelSize: 40
        font.family:"Noto Serif"
        font.italic:true
        text: "Available Options"
        y: heading.y + heading.height + 50
    }
    Rectangle {
        id:optionsArea
        objectName: "optionsArea"
        y:optionsHeading.y + optionsHeading.height + 10
        anchors.left:parent.left
        anchors.right:parent.right
        height:credit.y - y - 5

        Rectangle {
            id:topBar
            color: "black"
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.margins: 50
            anchors.topMargin: 0
            height:5
        }
        Rectangle {
            id:bottomBar
            color: "black"
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            anchors.margins: 50
            anchors.bottomMargin:0
            height:5
        }

        MouseArea {
            anchors.fill:parent
        }

    }

}

