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
import FingerTerm 1.0

Rectangle {
    id: lineView

    property var lines: [""]
    property int fontPointSize: util.fontSize
    property int cursorX: 1
    property int cursorWidth: 10
    property int cursorHeight: 10
    property int extraLines: util.extraLinesFromCursor
    property bool show

    y: show ? 0 : -(height+window.paddingSmall)
    color: "#404040"
    border.width: 2
    border.color: "#909090"
    radius: window.radiusSmall
    width: parent.width
    height: lineTextCol.height + 8*window.pixelRatio

    Text {
        id: fontHeightHack
        visible: false
        text: "X"
        font.family: util.fontFamily
        font.pointSize: lineView.fontPointSize
    }

    Rectangle {
        visible: vkb.active
        x: cursorX
        y: lineTextCol.y + fontHeightHack.height*(extraLines+1) - cursorHeight - 3
        width: cursorWidth
        height: cursorHeight
        color: "transparent"
        border.color: "#ffffff"
        border.width: 1
    }

    Column {
        id: lineTextCol

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 2*window.pixelRatio
        anchors.rightMargin: 2*window.pixelRatio

        Repeater {
            model: lines
            delegate: Item {
                height: fontHeightHack.height
                width: lineTextCol.width
                Text {
                    color: "#ffffff"
                    font.family: util.fontFamily
                    font.pointSize: lineView.fontPointSize
                    text: modelData
                    textFormat: Text.PlainText
                    wrapMode: Text.NoWrap
                    elide: Text.ElideNone
                    maximumLineCount: 1
                }
            }
        }
    }
}
