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
import QtQuick.Window 2.0

Item {
    id: root

    width: 1404
    height: 1872

    Binding {
        target: util
        property: "windowOrientation"
        value: page.orientation
    }

    Item {
        id: page

        property int orientation: forceOrientation ? forcedOrientation : Screen.orientation
        property bool forceOrientation: util.orientationMode != Util.OrientationAuto
        property int forcedOrientation: util.orientationMode == Util.OrientationLandscape ? Qt.LandscapeOrientation
                                                                                          : Qt.PortraitOrientation
        property bool portrait: rotation % 180 == 0

        width: portrait ? root.width : root.height
        height: portrait ? root.height : root.width
        anchors.centerIn: parent
        rotation: Screen.angleBetween(orientation, Screen.primaryOrientation)
        focus: true
        Keys.onPressed: {
            term.keyPress(event.key,event.modifiers,event.text);
        }

        Rectangle {
            id: window

            property string fgcolor: "black"
            property string bgcolor: "#000000"
            property int fontSize: 14*pixelRatio

            property int fadeOutTime: 80
            property int fadeInTime: 350
            property real pixelRatio: 1

            // layout constants
            property int buttonWidthSmall: 60*pixelRatio
            property int buttonWidthLarge: 180*pixelRatio
            property int buttonWidthHalf: 90*pixelRatio

            property int buttonHeightSmall: 48*pixelRatio
            property int buttonHeightLarge: 68*pixelRatio

            property int headerHeight: 20*pixelRatio

            property int radiusSmall: 5*pixelRatio
            property int radiusMedium: 10*pixelRatio
            property int radiusLarge: 15*pixelRatio

            property int paddingSmall: 5*pixelRatio
            property int paddingMedium: 10*pixelRatio

            property int fontSizeSmall: 8*pixelRatio
            property int fontSizeLarge: 12*pixelRatio

            property int uiFontSize: 8 * pixelRatio

            property int scrollBarWidth: 6*window.pixelRatio

            anchors.fill: parent
            color: bgcolor

            Lineview {
                id: lineView
                show: (util.keyboardMode == Util.KeyboardFade) && vkb.active
            }

            Keyboard {
                id: vkb
                property int mainHeight:vkb.height

                property int vil:1

                property bool visibleSetting: true

                y: parent.height-vkb.height
                visible: page.activeFocus && visibleSetting
            }

            // area that handles gestures/select/scroll modes and vkb-keypresses
            MultiPointTouchArea {
                id: multiTouchArea
                anchors.fill: parent

                property int firstTouchId: -1
                property var pressedKeys: ({})


                onPressed: {
                    touchPoints.forEach(function (touchPoint) {
                        if (multiTouchArea.firstTouchId == -1) {
                            multiTouchArea.firstTouchId = touchPoint.pointId;

                            //gestures c++ handler
                            textrender.mousePress(touchPoint.x, touchPoint.y);
                        }

                        var key = vkb.keyAt(touchPoint.x, touchPoint.y);
                        if (key != null) {
                            key.handlePress(multiTouchArea, touchPoint.x, touchPoint.y);
                        }
                        multiTouchArea.pressedKeys[touchPoint.pointId] = key;
                    });
                }
                onUpdated: {
                    touchPoints.forEach(function (touchPoint) {
                        if (multiTouchArea.firstTouchId == touchPoint.pointId) {
                            //gestures c++ handler
                            textrender.mouseMove(touchPoint.x, touchPoint.y);
                        }

                        var key = multiTouchArea.pressedKeys[touchPoint.pointId];
                        if (key != null) {
                            if (!key.handleMove(multiTouchArea, touchPoint.x, touchPoint.y)) {
                                delete multiTouchArea.pressedKeys[touchPoint.pointId];
                            }
                        }
                    });
                }
                onReleased: {
                    touchPoints.forEach(function (touchPoint) {
                        if (multiTouchArea.firstTouchId == touchPoint.pointId) {
                            // Toggle keyboard wake-up when tapping outside the keyboard, but:
                            //   - only when not scrolling (y-diff < 20 pixels)
                            if (touchPoint.y < vkb.y && touchPoint.startY < vkb.y &&
                                    Math.abs(touchPoint.y - touchPoint.startY) < 20) {
                                if (vkb.active) {
                                    window.sleepVKB();
                                } else {
                                    window.wakeVKB();
                                }
                            }

                            //gestures c++ handler
                            textrender.mouseRelease(touchPoint.x, touchPoint.y);
                            multiTouchArea.firstTouchId = -1;
                        }

                        var key = multiTouchArea.pressedKeys[touchPoint.pointId];
                        if (key != null) {
                            key.handleRelease(multiTouchArea, touchPoint.x, touchPoint.y);
                        }
                        delete multiTouchArea.pressedKeys[touchPoint.pointId];
                    });
                }
            }

            MouseArea {
                //top right corner menu button
                x: window.width - width
                width: menuImg.width + 60*window.pixelRatio
                height: menuImg.height + 30*window.pixelRatio
                opacity: 0.5
                onClicked: menu.showing = true

                Image {
                    id: menuImg

                    anchors.centerIn: parent
                    source: "icons/menu.png"
                    scale: window.pixelRatio
                }
            }

            Image {
                // terminal buffer scroll indicator
                source: "icons/scroll-indicator.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                visible: textrender.showBufferScrollIndicator
                scale: window.pixelRatio
            }

            TextRender {
                id: textrender

                property int duration
                property int cutAfter: height

                height: parent.height-vkb.mainHeight
                width: parent.width
                fontPointSize: util.fontSize
                opacity: (util.keyboardMode == Util.KeyboardFade && vkb.active) ? 0.3
                                                                                : 1.0
                allowGestures: !vkb.active && !menu.showing && !urlWindow.show && !aboutDialog.show && !layoutWindow.show

                Behavior on opacity {
                    NumberAnimation { duration: textrender.duration; easing.type: Easing.InOutQuad }
                }
                Behavior on y {
                    NumberAnimation { duration: textrender.duration; easing.type: Easing.InOutQuad }
                }

                onCutAfterChanged: {
                    // this property is used in the paint function, so make sure that the element gets
                    // painted with the updated value (might not otherwise happen because of caching)
                    textrender.redraw();
                }
            }

            Timer {
                id: fadeTimer

                interval: util.keyboardFadeOutDelay
                onTriggered: {
                    //window.sleepVKB();
                }
            }

            Timer {
                id: bellTimer

                interval: 80
            }

            Connections {
                target: util
                onVisualBell: bellTimer.start()
                onNotify: {
                    textNotify.text = msg;
                    textNotifyAnim.enabled = false;
                    textNotify.opacity = 1.0;
                    textNotifyAnim.enabled = true;
                    textNotify.opacity = 0;
                }
            }

            MenuFingerterm {
                id: menu
                anchors.fill: parent
            }

            Text {
                // shows large text notification in the middle of the screen (for gestures)
                id: textNotify

                anchors.centerIn: parent
                color: "#ffffff"
                opacity: 0
                font.pointSize: 40*window.pixelRatio

                Behavior on opacity {
                    id: textNotifyAnim
                    NumberAnimation { duration: 500; }
                }
            }

            NotifyWin {
                id: aboutDialog

                text: {
                    var str = "<font size=\"+3\">FingerTerm " + util.versionString() + "</font><br>\n" +
                            "<font size=\"+1\">" +
                            "by Heikki Holstila &lt;<a href=\"mailto:heikki.holstila@gmail.com?subject=FingerTerm\">heikki.holstila@gmail.com</a>&gt;<br><br>\n\n" +
                            "Config files for adjusting settings are at:<br>\n" +
                            util.configPath() + "/<br><br>\n" +
                            "Source code:<br>\n<a href=\"https://git.merproject.org/mer-core/fingerterm/\">https://git.merproject.org/mer-core/fingerterm/</a>"
                    if (term.rows != 0 && term.columns != 0) {
                        str += "<br><br>Current window title: <font color=\"gray\">" + util.windowTitle.substring(0,40) + "</font>"; //cut long window title
                        if(util.windowTitle.length>40)
                            str += "...";
                        str += "<br>Current terminal size: <font color=\"gray\">" + term.columns + "×" + term.rows + "</font>";
                        str += "<br>Charset: <font color=\"gray\">" + util.charset + "</font>";
                    }
                    str += "</font>";
                    return str;
                }
                onDismissed: util.showWelcomeScreen = false
            }

            NotifyWin {
                id: errorDialog
            }

            UrlWindow {
                id: urlWindow
            }

            LayoutWindow {
                id: layoutWindow
            }

            Connections {
                target: term
                onDisplayBufferChanged: window.displayBufferChanged()
            }

            function vkbKeypress(key,modifiers) {
                wakeVKB();
                term.keyPress(key,modifiers);
            }

            function wakeVKB()
            {
                if(!vkb.visibleSetting)
                    return;

                textrender.duration = window.fadeOutTime;
                fadeTimer.restart();
                vkb.active = true;
                setTextRenderAttributes();
            }

            function sleepVKB()
            {
                textrender.duration = window.fadeInTime;
                vkb.active = false;
                setTextRenderAttributes();
            }

            function setTextRenderAttributes()
            {
                if (util.keyboardMode == Util.KeyboardMove)
                {
                    vkb.visibleSetting = true;
                    if(vkb.active) {
                        var move = textrender.cursorPixelPos().y + textrender.fontHeight/2
                                + textrender.fontHeight*util.extraLinesFromCursor
                        if(move < vkb.y) {
                            textrender.y = 0;
                            textrender.cutAfter = vkb.y;
                        } else {
                            textrender.y = 0 - move + vkb.y
                            textrender.cutAfter = move;
                        }
                    } else {
                        textrender.cutAfter = textrender.height;
                        textrender.y = 0;
                    }
                }
                else if (util.keyboardMode == Util.KeyboardFade)
                {
                    vkb.visibleSetting = true;
                    textrender.cutAfter = textrender.height;
                    textrender.y = 0;
                }
                else // "off" (vkb disabled)
                {
                    vkb.visibleSetting = false;
                    textrender.cutAfter = textrender.height;
                    textrender.y = 0;
                }
            }

            function displayBufferChanged()
            {
                lineView.lines = term.printableLinesFromCursor(util.extraLinesFromCursor);
                lineView.cursorX = textrender.cursorPixelPos().x;
                lineView.cursorWidth = textrender.cursorPixelSize().width;
                lineView.cursorHeight = textrender.cursorPixelSize().height;
                setTextRenderAttributes();
            }

            Component.onCompleted: {
                if (util.showWelcomeScreen)
                    aboutDialog.show = true
                if (startupErrorMessage != "") {
                    showErrorMessage(startupErrorMessage)
                }
            }

            function showErrorMessage(string)
            {
                errorDialog.text = "<font size=\"+2\">" + string + "</font>";
                errorDialog.show = true
            }
        }
    }
}
