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

Rectangle {
    id: root

    property bool show

    width: window.width
    height: window.height
    color: "#000000"
    y: -height
    border.color: "#c0c0c0"
    border.width: 1
    radius: window.radiusMedium

    MouseArea {
        // event eater
        anchors.fill: parent
    }

    states: [
        State {
            name: "shown"
            when: root.show
            PropertyChanges { target: root; y: 0 }
        }
    ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation {
                properties: "y"
                duration: 200
                easing.type: Easing.InOutCubic
            }
        }
    ]
}
