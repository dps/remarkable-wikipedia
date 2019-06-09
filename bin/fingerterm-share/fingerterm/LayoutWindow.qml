/*
    Copyright 2011-2012 Heikki Holstila <heikki.holstila@gmail.com>

    This file is part of FingerTerm.

    FingerTerm is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    FingerTerm is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with FingerTerm.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0

PopupWindow {
    id: layoutWindow

    property var layouts: [""]

    Component {
        id: listDelegate
        Rectangle {
            color: util.keyboardLayout === modelData ? "#909090" : "#404040"
            width: parent.width
            height: selectButton.height+4*window.pixelRatio
            border.width: 1
            border.color: "#ffffff"
            radius: window.radiusSmall
            clip: true

            Text {
                text: modelData
                color: "#ffffff"
                anchors.verticalCenter: parent.verticalCenter
                x: 8*window.pixelRatio
                width: selectButton.x - x
                font.pointSize: window.uiFontSize
                elide: Text.ElideRight
            }
            Button {
                id: selectButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "Select"
                width: 70*window.pixelRatio
                anchors.rightMargin: window.paddingSmall
                onClicked: {
                    util.keyboardLayout = modelData
                    layoutWindow.show = false
                    util.notifyText(modelData)
                }
            }
        }
    }

    Text {
        id: titleText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: "#ffffff"
        text: "Keyboard layout"
        font.pointSize: window.uiFontSize + 4*window.pixelRatio;
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: titleText.height + 4*window.pixelRatio
        delegate: listDelegate
        model: layoutWindow.layouts
        spacing: window.paddingSmall
        anchors.margins: window.paddingSmall
        clip: true
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: window.paddingMedium
        text: "Back"
        onClicked: layoutWindow.show = false
    }
}
