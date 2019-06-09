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
    id: key

    property string label
    property string label_alt
    property int code
    property int code_alt
    property int currentCode: (shiftActive && label_alt != '') ? code_alt : code
    property string currentLabel: (shiftActive && label_alt != '') ? label_alt : label
    property bool sticky        // can key be stickied?
    property bool becomesSticky // will this become sticky after release?
    property int stickiness     // current stickiness status
    property real labelOpacity: keyboard.active ? 1.0 : 0.3

    // mouse input handling
    property bool isClick
    property bool shiftActive: (keyboard.keyModifiers & Qt.ShiftModifier) && !sticky

    width: window.width/12   // some default
    height: window.height/8 < 55*window.pixelRatio ? window.height/8 : 55*window.pixelRatio
    color: label=="" ? "transparent" : (isClick || keyPressHighlight.running ? keyboard.keyHilightBgColor : keyboard.keyBgColor)
    border.color: label=="" ? "transparent" : keyboard.keyBorderColor
    border.width: 1
    radius: window.radiusSmall

    Image {
        id: keyImage
        anchors.centerIn: parent
        opacity: key.labelOpacity
        source: { if(key.label.length>1 && key.label.charAt(0)==':') return "icons/"+key.label.substring(1)+".png"; else return ""; }
        scale: window.pixelRatio
    }

    Column {
        visible: keyImage.source == ""
        anchors.centerIn: parent
        spacing: -17*window.pixelRatio

        Text {
            id: keyAltLabel
            property bool highlighted: key.shiftActive

            anchors.horizontalCenter: parent.horizontalCenter

            text: key.label_alt
            color: keyboard.keyFgColor

            opacity: key.labelOpacity * (highlighted ? 1.0 : 0.2)
            Behavior on opacity { NumberAnimation { duration: 100 } }

            font.family: util.fontFamily
            font.pointSize: (highlighted ? window.fontSizeLarge : window.fontSizeSmall) * (text.length > 1 ? 0.5 : 1.0)
            Behavior on font.pointSize { NumberAnimation { duration: 100 } }
        }

        Text {
            id: keyLabel
            property bool highlighted: key.label_alt == '' || !key.shiftActive

            anchors.horizontalCenter: parent.horizontalCenter

            text: {
                if (key.label.length == 1 && key.label_alt == '') {
                    if (key.shiftActive) {
                        return key.label.toUpperCase();
                    } else {
                        return key.label.toLowerCase();
                    }
                }

                return key.label;
            }

            color: keyboard.keyFgColor

            opacity: key.labelOpacity * (highlighted ? 1.0 : 0.2)
            Behavior on opacity { NumberAnimation { duration: 100 } }

            font.family: util.fontFamily
            font.pointSize: (highlighted ? window.fontSizeLarge : window.fontSizeSmall) * (text.length > 1 ? 0.5 : 1.0)
            Behavior on font.pointSize { NumberAnimation { duration: 100 } }
        }
    }

    Rectangle {
        id: stickIndicator
        visible: sticky && stickiness>0
        color: keyboard.keyHilightBgColor
        anchors.fill: parent
        radius: key.radius
        opacity: 0.5
        anchors.topMargin: key.height/2
    }

    function handlePress(touchArea, x, y) {
        isClick = true;

        keyboard.currentKeyPressed = key;
        util.keyPressFeedback();

        keyRepeatStarter.start();
        keyPressHighlight.restart()

        if (sticky) {
            keyboard.keyModifiers |= code;
            key.becomesSticky = true;
            keyboard.currentStickyPressed = key;
        } else {
            if (keyboard.currentStickyPressed != null) {
                // Pressing a non-sticky key while a sticky key is pressed:
                // the sticky key will not become sticky when released
                keyboard.currentStickyPressed.becomesSticky = false;
            }
        }
    }

    function handleMove(touchArea, x, y) {
        var mappedPoint = key.mapFromItem(touchArea, x, y)
        if (!key.contains(Qt.point(mappedPoint.x, mappedPoint.y))) {
            key.handleRelease(touchArea, x, y);
            return false;
        }

        return true;
    }

    function handleRelease(touchArea, x, y) {
        key.isClick = false
        keyRepeatStarter.stop();
        keyRepeatTimer.stop();

        keyboard.currentKeyPressed = null;

        if (sticky && !becomesSticky) {
            keyboard.keyModifiers &= ~code
            keyboard.currentStickyPressed = null;
        }

        if (vkb.keyAt(x, y) == key) {
            util.keyReleaseFeedback();

            if (key.sticky && key.becomesSticky) {
                setStickiness(-1);
            }

            if (shiftActive && code_alt != 0 && code_alt != code) {
                // Do not apply shift on alt code that are accessible
                // only with shift.
                window.vkbKeypress(currentCode, keyboard.keyModifiers & ~Qt.ShiftModifier);
            } else {
                window.vkbKeypress(currentCode, keyboard.keyModifiers);
            }

            // first non-sticky press will cause the sticky to be released
            if( !sticky && keyboard.resetSticky && keyboard.resetSticky !== key ) {
                resetSticky.setStickiness(0);
            }
        }
    }

    Timer {
        id: keyRepeatStarter
        interval: 400
        onTriggered: {
            keyRepeatTimer.start();
        }
    }

    Timer {
        id: keyRepeatTimer
        repeat: true
        triggeredOnStart: true
        interval: 80
        onTriggered: {
            window.vkbKeypress(currentCode, keyboard.keyModifiers);
        }
    }

    Timer {
        id: keyPressHighlight
        interval: keyboard.feedbackDuration
    }

    function setStickiness(val)
    {
        if(sticky) {
            if( keyboard.resetSticky && keyboard.resetSticky !== key ) {
                resetSticky.setStickiness(0)
            }

            if(val===-1)
                stickiness = (stickiness+1) % 3
            else
                stickiness = val

            // stickiness == 0 -> not pressed
            // stickiness == 1 -> release after next keypress
            // stickiness == 2 -> keep pressed

            if(stickiness>0) {
                keyboard.keyModifiers |= code
            } else {
                keyboard.keyModifiers &= ~code
            }

            keyboard.resetSticky = null

            if(stickiness==1) {
                stickIndicator.anchors.topMargin = key.height/2
                keyboard.resetSticky = key
            } else if(stickiness==2) {
                stickIndicator.anchors.topMargin = 0
            }
        }
    }
}
