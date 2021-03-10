// This code is by Nathaniel van Diepen and used with permission.
// under the MIT license.
// https://github.com/Eeems/oxidize/blob/master/LICENSE.md
import QtQuick 2.9
import "."


Item {
    objectName: "keyboard"
    id: keyboard
    clip: true
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    property int page: 0
    property bool hasCaps: false
    property bool hasShift: false
    property bool hasAlt: false
    property bool hasCtrl: false
    property bool hasMeta: false

    function charPress(text, modifiers) {
        console.log("charPress " + text + " " + modifiers);
        onChar(text);
    }
    function keyPress(text, modifiers) {
        if (text === "Backspace") {
            onChar("key-del");
        } else if (text === "Space") {
            onChar("key-spc");
        }
    }
    function hide(){
        keyboard.visible = false;
        keyboard.focus = true;
    }

    function each(column, fn){
        for(var i = 0; i < column.children.length; i++){
            var row = column.children[i];
            for(var y = 0; y < row.children.length; y++){
                fn(row.children[y]);
            }
        }
    }
    function caps(state){
        keyboard.hasCaps = state;
        keyboard.hasShift = !keyboard.hasShift;
    }
    function shift(state){
        keyboard.hasShift = state;
    }
    function ctrl(state){
        keyboard.haCtrl = state;
    }
    function alt(state){
        keyboard.hasAlt = state;
    }
    function meta(state){
        keyboard.hasMeta = state;
    }

    width: parent.width
    height: 480
    MouseArea { anchors.fill: keyboard }
    Rectangle {
        color: "black"
        anchors.fill: keyboard
        Column {
            id: qwerty
            anchors.centerIn: parent
            spacing: 4
            visible: page == 0
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "`"; shifttext: "~" }
                KeyboardKey { text: "1"; shifttext: "!" }
                KeyboardKey { text: "2"; shifttext: "@" }
                KeyboardKey { text: "3"; shifttext: "#" }
                KeyboardKey { text: "4"; shifttext: "$" }
                KeyboardKey { text: "5"; shifttext: "%" }
                KeyboardKey { text: "6"; shifttext: "^" }
                KeyboardKey { text: "7"; shifttext: "&" }
                KeyboardKey { text: "8"; shifttext: "*" }
                KeyboardKey { text: "9"; shifttext: ")" }
                KeyboardKey { text: "0"; shifttext: "(" }
                KeyboardKey { text: "-"; shifttext: "_" }
                KeyboardKey { text: "="; shifttext: "+" }
                KeyboardKey { text: "Backspace"; size: 2; key: Qt.Key_Backspace; fontsize: 6 }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "Tab"; size: 1; key: Qt.Key_Tab }
                KeyboardKey { text: "q"; shifttext: "Q" }
                KeyboardKey { text: "w"; shifttext: "W" }
                KeyboardKey { text: "e"; shifttext: "E" }
                KeyboardKey { text: "r"; shifttext: "R" }
                KeyboardKey { text: "t"; shifttext: "T" }
                KeyboardKey { text: "y"; shifttext: "Y" }
                KeyboardKey { text: "u"; shifttext: "U" }
                KeyboardKey { text: "i"; shifttext: "I" }
                KeyboardKey { text: "o"; shifttext: "O" }
                KeyboardKey { text: "p"; shifttext: "P" }
                KeyboardKey { text: "["; shifttext: "{" }
                KeyboardKey { text: "]"; shifttext: "}" }
                KeyboardKey { text: "\\"; shifttext: "|" }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { id: caps; text: "Caps"; key: Qt.Key_CapsLock; size: 2; onClick: keyboard.caps(this.state()); toggle: true }
                KeyboardKey { text: "a"; shifttext: "A" }
                KeyboardKey { text: "s"; shifttext: "S" }
                KeyboardKey { text: "d"; shifttext: "D" }
                KeyboardKey { text: "f"; shifttext: "F" }
                KeyboardKey { text: "g"; shifttext: "G" }
                KeyboardKey { text: "h"; shifttext: "H" }
                KeyboardKey { text: "j"; shifttext: "J" }
                KeyboardKey { text: "k"; shifttext: "K" }
                KeyboardKey { text: "l"; shifttext: "L" }
                KeyboardKey { text: ";"; shifttext: ":" }
                KeyboardKey { text: "'"; shifttext: "\"" }
                KeyboardKey { text: "↩"; size: 2; key: Qt.Key_Enter }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { id: lshift; text: "Shift"; key: Qt.Key_Shift; size: 2; onClick: keyboard.shift(this.state()); toggle: true }
                KeyboardKey { text: "z"; shifttext: "Z" }
                KeyboardKey { text: "x"; shifttext: "X" }
                KeyboardKey { text: "c"; shifttext: "C" }
                KeyboardKey { text: "v"; shifttext: "V" }
                KeyboardKey { text: "b"; shifttext: "B" }
                KeyboardKey { text: "n"; shifttext: "N" }
                KeyboardKey { text: "m"; shifttext: "M" }
                KeyboardKey { text: ","; shifttext: "<" }
                KeyboardKey { text: "."; shifttext: ">" }
                KeyboardKey { text: "/"; shifttext: "?" }
                KeyboardKey { id: rshift; text: "Shift"; key: Qt.Key_Shift; size: 2; onClick: keyboard.shift(this.state()); toggle: true }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { id: lctrl; text: "Ctrl"; key: Qt.Key_Control; onClick: keyboard.ctrl(this.state()); toggle: true }
                KeyboardKey { id: lmeta; text: "Meta"; key: Qt.Key_Meta; onClick: keyboard.meta(this.state()); toggle: true }
                KeyboardKey { id: lalt; text: "Alt"; key: Qt.Key_Alt; onClick: keyboard.alt(this.state()); toggle: true }
                KeyboardKey { text: "Space"; size: 6; key: Qt.Key_Space; value: " " }
                KeyboardKey { id: ralt; text: "Alt"; key: Qt.Key_AltGr; onClick: keyboard.alt(this.state()); toggle: true }
                KeyboardKey { id: rmeta; text: "Meta"; key: Qt.Key_Meta; onClick: keyboard.meta(this.state()); toggle: true }
                KeyboardKey { text: "Menu"; key: Qt.Key_Menu }
                KeyboardKey { id: rctrl; text: "Ctrl"; key: Qt.Key_Control; onClick: keyboard.ctrl(this.state()); toggle: true }
            }
        }
        Column {
            id: more
            anchors.centerIn: parent
            spacing: 4
            visible: page == 1
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "😀" }
                KeyboardKey { text: "😁" }
                KeyboardKey { text: "😂" }
                KeyboardKey { text: "😃" }
                KeyboardKey { text: "😄" }
                KeyboardKey { text: "😅" }
                KeyboardKey { text: "😆" }
                KeyboardKey { text: "😉" }
                KeyboardKey { text: "😊" }
                KeyboardKey { text: "😋" }
                KeyboardKey { text: "😎" }
                KeyboardKey { text: "😍" }
                KeyboardKey { text: "😘" }
                KeyboardKey { text: "Backspace"; size: 2; key: Qt.Key_Backspace; fontsize: 6 }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "😗" }
                KeyboardKey { text: "😙" }
                KeyboardKey { text: "😚" }
                KeyboardKey { text: "☺️" }
                KeyboardKey { text: "😐" }
                KeyboardKey { text: "😑" }
                KeyboardKey { text: "😶" }
                KeyboardKey { text: "😏" }
                KeyboardKey { text: "😣" }
                KeyboardKey { text: "😥" }
                KeyboardKey { text: "😮" }
                KeyboardKey { text: "😯" }
                KeyboardKey { text: "😪" }
                KeyboardKey { text: "😫" }
                KeyboardKey { text: "😴" }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "😌" }
                KeyboardKey { text: "😛" }
                KeyboardKey { text: "😜" }
                KeyboardKey { text: "😝" }
                KeyboardKey { text: "😒" }
                KeyboardKey { text: "😓" }
                KeyboardKey { text: "😔" }
                KeyboardKey { text: "😕" }
                KeyboardKey { text: "😲" }
                KeyboardKey { text: "😖" }
                KeyboardKey { text: "😞" }
                KeyboardKey { text: "😟" }
                KeyboardKey { text: "😢" }
                KeyboardKey { text: "↩"; size: 2; key: Qt.Key_Enter }
            }
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "😭" }
                KeyboardKey { text: "😦" }
                KeyboardKey { text: "😧" }
                KeyboardKey { text: "😨" }
                KeyboardKey { text: "😩" }
                KeyboardKey { text: "😰" }
                KeyboardKey { text: "😱" }
                KeyboardKey { text: "😳" }
                KeyboardKey { text: "😵" }
                KeyboardKey { text: "😡" }
                KeyboardKey { text: "😠" }
                KeyboardKey { text: "😷" }
                KeyboardKey { text: "😇" }
                KeyboardKey { text: "😈" }
                KeyboardKey { text: "💩" }
            }
            //
            Row {
                spacing: parent.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                KeyboardKey { text: "😺" }
                KeyboardKey { text: "😸" }
                KeyboardKey { text: "😹" }
                KeyboardKey { text: "😻" }
                KeyboardKey { text: "Space"; size: 4; key: Qt.Key_Space; value: " " }
                KeyboardKey { text: "😼" }
                KeyboardKey { text: "😽" }
                KeyboardKey { text: "🙀" }
                KeyboardKey { text: "😿" }
                KeyboardKey { text: "😾" }
            }
        }
        // People and Fantasy
        //👶 👧 🧒 👦 👩 🧑 👨 👵 🧓 👴 👲 👳♀️ 👳♂️ 🧕 🧔 👱♂️ 👱♀️ 👨🦰 👩🦰 👨🦱 👩🦱 👨🦲 👩🦲 👨🦳 👩🦳 🦸♀️ 🦸♂️ 🦹♀️ 🦹♂️ 👮♀️ 👮♂️ 👷♀️ 👷♂️ 💂♀️ 💂♂️ 🕵️♀️ 🕵️♂️ 👩⚕️ 👨⚕️ 👩🌾 👨🌾 👩🍳 👨🍳 👩🎓 👨🎓 👩🎤 👨🎤 👩🏫 👨🏫 👩🏭 👨🏭 👩💻 👨💻 👩💼 👨💼 👩🔧 👨🔧 👩🔬 👨🔬 👩🎨 👨🎨 👩🚒 👨🚒 👩✈️ 👨✈️ 👩🚀 👨🚀 👩⚖️ 👨⚖️ 👰 🤵 👸 🤴 🤶 🎅 🧙♀️ 🧙♂️ 🧝♀️ 🧝♂️ 🧛♀️ 🧛♂️ 🧟♀️ 🧟♂️ 🧞♀️ 🧞♂️ 🧜♀️ 🧜♂️ 🧚♀️ 🧚♂️ 👼 🤰 🤱 🙇♀️ 🙇♂️ 💁♀️ 💁♂️ 🙅♀️ 🙅♂️ 🙆♀️ 🙆♂️ 🙋♀️ 🙋♂️ 🤦♀️ 🤦♂️ 🤷♀️ 🤷♂️ 🙎♀️ 🙎♂️ 🙍♀️ 🙍♂️ 💇♀️ 💇♂️ 💆♀️ 💆♂️ 🧖♀️ 🧖♂️ 💅 🤳 💃 🕺 👯♀️ 👯♂️ 🕴 🚶♀️ 🚶♂️ 🏃♀️ 🏃♂️ 👫 👭 👬 💑 👩❤️👩 👨❤️👨 💏 👩❤️💋👩 👨❤️💋👨 👪 👨👩👧 👨👩👧👦 👨👩👦👦 👨👩👧👧 👩👩👦 👩👩👧 👩👩👧👦 👩👩👦👦 👩👩👧👧 👨👨👦 👨👨👧 👨👨👧👦 👨👨👦👦 👨👨👧👧 👩👦 👩👧 👩👧👦 👩👦👦 👩👧👧 👨👦 👨👧 👨👧👦 👨👦👦 👨👧👧 🤲 👐 🙌 👏 🤝 👍 👎 👊 ✊ 🤛 🤜 🤞 ✌️ 🤟 🤘 👌 👈 👉 👆 👇 ☝️ ✋ 🤚 🖐 🖖 👋 🤙 💪 🦵 🦶 🖕 ✍️ 🙏 💍 💄 💋 👄 👅 👂 👃 👣 👁 👀 🧠 🦴 🦷 🗣 👤 👥
        // Clothing/Accessories
        //🧥 👚 👕 👖 👔 👗 👙 👘 👠 👡 👢 👞 👟 🥾 🥿 🧦 🧤 🧣 🎩 🧢 👒 🎓 ⛑ 👑 👝 👛 👜 💼 🎒 👓 🕶 🥽 🥼 🌂 🧵 🧶
        // Animals
        //🐶 🐱 🐭 🐹 🐰 🦊 🦝 🐻 🐼 🦘 🦡 🐨 🐯 🦁 🐮 🐷 🐽 🐸 🐵 🙈 🙉 🙊 🐒 🐔 🐧 🐦 🐤 🐣 🐥 🦆 🦢 🦅 🦉 🦚 🦜 🦇 🐺 🐗 🐴 🦄 🐝 🐛 🦋 🐌 🐚 🐞 🐜 🦗 🕷 🕸 🦂 🦟 🦠 🐢 🐍 🦎 🦖 🦕 🐙 🦑 🦐 🦀 🐡 🐠 🐟 🐬 🐳 🐋 🦈 🐊 🐅 🐆 🦓 🦍 🐘 🦏 🦛 🐪 🐫 🦙 🦒 🐃 🐂 🐄 🐎 🐖 🐏 🐑 🐐 🦌 🐕 🐩 🐈 🐓 🦃 🕊 🐇 🐁 🐀 🐿 🦔 🐾 🐉 🐲 🌵 🎄 🌲 🌳 🌴 🌱 🌿 ☘️ 🍀 🎍 🎋 🍃 🍂 🍁 🍄 🌾 💐 🌷 🌹 🥀 🌺 🌸 🌼 🌻 🌞 🌝 🌛 🌜 🌚 🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔 🌙 🌎 🌍 🌏 💫 ⭐️ 🌟 ✨ ⚡️ ☄️ 💥 🔥 🌪 🌈 ☀️ 🌤 ⛅️ 🌥 ☁️ 🌦 🌧 ⛈ 🌩 🌨 ❄️ ☃️ ⛄️ 🌬 💨 💧 💦 ☔️ ☂️ 🌊 🌫
        // Food/Drink
        //🍏 🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🍈 🍒 🍑 🍍 🥭 🥥 🥝 🍅 🍆 🥑 🥦 🥒 🥬 🌶 🌽 🥕 🥔 🍠 🥐 🍞 🥖 🥨 🥯 🧀 🥚 🍳 🥞 🥓 🥩 🍗 🍖 🌭 🍔 🍟 🍕 🥪 🥙 🌮 🌯 🥗 🥘 🥫 🍝 🍜 🍲 🍛 🍣 🍱 🥟 🍤 🍙 🍚 🍘 🍥 🥮 🥠 🍢 🍡 🍧 🍨 🍦 🥧 🍰 🎂 🍮 🍭 🍬 🍫 🍿 🧂 🍩 🍪 🌰 🥜 🍯 🥛 🍼 ☕️ 🍵 🥤 🍶 🍺 🍻 🥂 🍷 🥃 🍸 🍹 🍾 🥄 🍴 🍽 🥣 🥡 🥢
        // Activities/Sports
        //⚽️ 🏀 🏈 ⚾️ 🥎 🏐 🏉 🎾 🥏 🎱 🏓 🏸 🥅 🏒 🏑 🥍 🏏 ⛳️ 🏹 🎣 🥊 🥋 🎽 ⛸ 🥌 🛷 🛹 🎿 ⛷ 🏂 🏋️♀️ 🏋🏻♀️ 🏋🏼♀️ 🏋🏽♀️ 🏋🏾♀️ 🏋🏿♀️ 🏋️♂️ 🏋🏻♂️ 🏋🏼♂️ 🏋🏽♂️ 🏋🏾♂️ 🏋🏿♂️ 🤼♀️ 🤼♂️ 🤸♀️ 🤸🏻♀️ 🤸🏼♀️ 🤸🏽♀️ 🤸🏾♀️ 🤸🏿♀️ 🤸♂️ 🤸🏻♂️ 🤸🏼♂️ 🤸🏽♂️ 🤸🏾♂️ 🤸🏿♂️ ⛹️♀️ ⛹🏻♀️ ⛹🏼♀️ ⛹🏽♀️ ⛹🏾♀️ ⛹🏿♀️ ⛹️♂️ ⛹🏻♂️ ⛹🏼♂️ ⛹🏽♂️ ⛹🏾♂️ ⛹🏿♂️ 🤺 🤾♀️ 🤾🏻♀️ 🤾🏼♀️ 🤾🏾♀️ 🤾🏾♀️ 🤾🏿♀️ 🤾♂️ 🤾🏻♂️ 🤾🏼♂️ 🤾🏽♂️ 🤾🏾♂️ 🤾🏿♂️ 🏌️♀️ 🏌🏻♀️ 🏌🏼♀️ 🏌🏽♀️ 🏌🏾♀️ 🏌🏿♀️ 🏌️♂️ 🏌🏻♂️ 🏌🏼♂️ 🏌🏽♂️ 🏌🏾♂️ 🏌🏿♂️ 🏇 🏇🏻 🏇🏼 🏇🏽 🏇🏾 🏇🏿 🧘♀️ 🧘🏻♀️ 🧘🏼♀️ 🧘🏽♀️ 🧘🏾♀️ 🧘🏿♀️ 🧘♂️ 🧘🏻♂️ 🧘🏼♂️ 🧘🏽♂️ 🧘🏾♂️ 🧘🏿♂️ 🏄♀️ 🏄🏻♀️ 🏄🏼♀️ 🏄🏽♀️ 🏄🏾♀️ 🏄🏿♀️ 🏄♂️ 🏄🏻♂️ 🏄🏼♂️ 🏄🏽♂️ 🏄🏾♂️ 🏄🏿♂️ 🏊♀️ 🏊🏻♀️ 🏊🏼♀️ 🏊🏽♀️ 🏊🏾♀️ 🏊🏿♀️ 🏊♂️ 🏊🏻♂️ 🏊🏼♂️ 🏊🏽♂️ 🏊🏾♂️ 🏊🏿♂️ 🤽♀️ 🤽🏻♀️ 🤽🏼♀️ 🤽🏽♀️ 🤽🏾♀️ 🤽🏿♀️ 🤽♂️ 🤽🏻♂️ 🤽🏼♂️ 🤽🏽♂️ 🤽🏾♂️ 🤽🏿♂️ 🚣♀️ 🚣🏻♀️ 🚣🏼♀️ 🚣🏽♀️ 🚣🏾♀️ 🚣🏿♀️ 🚣♂️ 🚣🏻♂️ 🚣🏼♂️ 🚣🏽♂️ 🚣🏾♂️ 🚣🏿♂️ 🧗♀️ 🧗🏻♀️ 🧗🏼♀️ 🧗🏽♀️ 🧗🏾♀️ 🧗🏿♀️ 🧗♂️ 🧗🏻♂️ 🧗🏼♂️ 🧗🏽♂️ 🧗🏾♂️ 🧗🏿♂️ 🚵♀️ 🚵🏻♀️ 🚵🏼♀️ 🚵🏽♀️ 🚵🏾♀️ 🚵🏿♀️ 🚵♂️ 🚵🏻♂️ 🚵🏼♂️ 🚵🏽♂️ 🚵🏾♂️ 🚵🏿♂️ 🚴♀️ 🚴🏻♀️ 🚴🏼♀️ 🚴🏽♀️ 🚴🏾♀️ 🚴🏿♀️ 🚴♂️ 🚴🏻♂️ 🚴🏼♂️ 🚴🏽♂️ 🚴🏾♂️ 🚴🏿♂️ 🏆 🥇 🥈 🥉 🏅 🎖 🏵 🎗 🎫 🎟 🎪 🤹♀️ 🤹🏻♀️ 🤹🏼♀️ 🤹🏽♀️ 🤹🏾♀️ 🤹🏿♀️ 🤹♂️ 🤹🏻♂️ 🤹🏼♂️ 🤹🏽♂️ 🤹🏾♂️ 🤹🏿♂️ 🎭 🎨 🎬 🎤 🎧 🎼 🎹 🥁 🎷 🎺 🎸 🎻 🎲 🧩 ♟ 🎯 🎳 🎮 🎰
        // Travel/Places
        //🚗 🚕 🚙 🚌 🚎 🏎 🚓 🚑 🚒 🚐 🚚 🚛 🚜 🛴 🚲 🛵 🏍 🚨 🚔 🚍 🚘 🚖 🚡 🚠 🚟 🚃 🚋 🚞 🚝 🚄 🚅 🚈 🚂 🚆 🚇 🚊 🚉 ✈️ 🛫 🛬 🛩 💺 🛰 🚀 🛸 🚁 🛶 ⛵️ 🚤 🛥 🛳 ⛴ 🚢 ⚓️ ⛽️ 🚧 🚦 🚥 🚏 🗺 🗿 🗽 🗼 🏰 🏯 🏟 🎡 🎢 🎠 ⛲️ ⛱ 🏖 🏝 🏜 🌋 ⛰ 🏔 🗻 🏕 ⛺️ 🏠 🏡 🏘 🏚 🏗 🏭 🏢 🏬 🏣 🏤 🏥 🏦 🏨 🏪 🏫 🏩 💒 🏛 ⛪️ 🕌 🕍 🕋 ⛩ 🛤 🛣 🗾 🎑 🏞 🌅 🌄 🌠 🎇 🎆 🌇 🌆 🏙 🌃 🌌 🌉 🌁
        // Objects
        //⌚️ 📱 📲 💻 ⌨️ 🖥 🖨 🖱 🖲 🕹 🗜 💽 💾 💿 📀 📼 📷 📸 📹 🎥 📽 🎞 📞 ☎️ 📟 📠 📺 📻 🎙 🎚 🎛 ⏱ ⏲ ⏰ 🕰 ⌛️ ⏳ 📡 🔋 🔌 💡 🔦 🕯 🗑 🛢 💸 💵 💴 💶 💷 💰 💳 🧾 💎 ⚖️ 🔧 🔨 ⚒ 🛠 ⛏ 🔩 ⚙️ ⛓ 🔫 💣 🔪 🗡 ⚔️ 🛡 🚬 ⚰️ ⚱️ 🏺 🧭 🧱 🔮 🧿 🧸 📿 💈 ⚗️ 🔭 🧰 🧲 🧪 🧫 🧬 🧯 🔬 🕳 💊 💉 🌡 🚽 🚰 🚿 🛁 🛀 🛀🏻 🛀🏼 🛀🏽 🛀🏾 🛀🏿 🧴 🧵 🧶 🧷 🧹 🧺 🧻 🧼 🧽 🛎 🔑 🗝 🚪 🛋 🛏 🛌 🖼 🛍 🧳 🛒 🎁 🎈 🎏 🎀 🎊 🎉 🧨 🎎 🏮 🎐 🧧 ✉️ 📩 📨 📧 💌 📥 📤 📦 🏷 📪 📫 📬 📭 📮 📯 📜 📃 📄 📑 📊 📈 📉 🗒 🗓 📆 📅 📇 🗃 🗳 🗄 📋 📁 📂 🗂 🗞 📰 📓 📔 📒 📕 📗 📘 📙 📚 📖 🔖 🔗 📎 🖇 📐 📏 📌 📍 ✂️ 🖊 🖋 ✒️ 🖌 🖍 📝 ✏️ 🔍 🔎 🔏 🔐 🔒 🔓
        // Symbols
        //❤️ 🧡 💛 💚 💙 💜 🖤 💔 ❣️ 💕 💞 💓 💗 💖 💘 💝 💟 ☮️ ✝️ ☪️ 🕉 ☸️ ✡️ 🔯 🕎 ☯️ ☦️ 🛐 ⛎ ♈️ ♉️ ♊️ ♋️ ♌️ ♍️ ♎️ ♏️ ♐️ ♑️ ♒️ ♓️ 🆔 ⚛️ 🉑 ☢️ ☣️ 📴 📳 🈶 🈚️ 🈸 🈺 🈷️ ✴️ 🆚 💮 🉐 秘️ 祝️ 🈴 🈵 🈹 🈲 🅰️ 🅱️ 🆎 🆑 🅾️ 🆘 ❌ ⭕️ 🛑 ⛔️ 📛 🚫 💯 💢 ♨️ 🚷 🚯 🚳 🚱 🔞 📵 🚭 ❗️ ❕ ❓ ❔ ‼️ ⁉️ 🔅 🔆 〽️ ⚠️ 🚸 🔱 ⚜️ 🔰 ♻️ ✅ 🈯️ 💹 ❇️ ✳️ ❎ 🌐 💠 Ⓜ️ 🌀 💤 🏧 🚾 ♿️ 🅿️ 🈳 🈂️ 🛂 🛃 🛄 🛅 🚹 🚺 🚼 🚻 🚮 🎦 📶 🈁 🔣 ℹ️ 🔤 🔡 🔠 🆖 🆗 🆙 🆒 🆕 🆓 0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 🔢 #️⃣ *️⃣ ⏏️ ▶️ ⏸ ⏯ ⏹ ⏺ ⏭ ⏮ ⏩ ⏪ ⏫ ⏬ ◀️ 🔼 🔽 ➡️ ⬅️ ⬆️ ⬇️ ↗️ ↘️ ↙️ ↖️ ↕️ ↔️ ↪️ ↩️ ⤴️ ⤵️ 🔀 🔁 🔂 🔄 🔃 🎵 🎶 ➕ ➖ ➗ ✖️ ♾ 💲 💱 ™️ ©️ ®️ ﹋️ ➰ ➿ 🔚 🔙 🔛 🔝 🔜 ✔️ ☑️ 🔘 ⚪️ ⚫️ 🔴 🔵 🔺 🔻 🔸 🔹 🔶 🔷 🔳 🔲 ▪️ ▫️ ◾️ ◽️ ◼️ ◻️ ⬛️ ⬜️ 🔈 🔇 🔉 🔊 🔔 🔕 📣 📢 👁🗨 💬 💭 🗯 ♠️ ♣️ ♥️ ♦️ 🃏 🎴 🀄️ 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 🕜 🕝 🕞 🕟 🕠 🕡 🕢 🕣 🕤 🕥 🕦 🕧
        // Flags
        //🏳️ 🏴 🏁 🚩 🏳️🌈 🏴☠️ 🇦🇫 🇦🇽 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇶 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇮🇴 🇻🇬 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇮🇨 🇨🇻 🇧🇶 🇰🇾 🇨🇫 🇹🇩 🇨🇱 🇨🇳 🇨🇽 🇨🇨 🇨🇴 🇰🇲 🇨🇬 🇨🇩 🇨🇰 🇨🇷 🇨🇮 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇪🇺 🇫🇰 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇵🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇩🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇱 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇬 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇲 🇮🇱 🇮🇹 🇯🇲 🇯🇵 🎌 🇯🇪 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇽🇰 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇭 🇲🇶 🇲🇷 🇲🇺 🇾🇹 🇲🇽 🇫🇲 🇲🇩 🇲🇨 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇷 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇳🇫 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇳 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇪 🇷🇴 🇷🇺 🇷🇼 🇼🇸 🇸🇲 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇽 🇸🇰 🇸🇮 🇬🇸 🇸🇧 🇸🇴 🇿🇦 🇰🇷 🇸🇸 🇪🇸 🇱🇰 🇧🇱 🇸🇭 🇰🇳 🇱🇨 🇵🇲 🇻🇨 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇼 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇰 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇻🇮 🇺🇬 🇺🇦 🇦🇪 🇬🇧 🏴󠁧󠁢󠁥󠁮󠁧󠁿 🏴󠁧󠁢󠁳󠁣󠁴󠁿 🏴󠁧󠁢󠁷󠁬󠁳󠁿 🇺🇳 🇺🇸 🇺🇾 🇺🇿 🇻🇺 🇻🇦 🇻🇪 🇻🇳 🇼🇫 🇪🇭 🇾🇪 🇿🇲 🇿🇼
        // New
        //🥱 🤏 🦾 🦿 🦻 🧏 🧏♂️ 🧏♀️ 🧍 🧍♂️ 🧍♀️ 🧎 🧎♂️ 🧎♀️ 👨🦯 👩🦯 👨🦼 👩🦼 👨🦽 👩🦽 🦧 🦮 🐕🦺 🦥 🦦 🦨 🦩 🧄 🧅 🧇 🧆 🧈 🦪 🧃 🧉 🧊 🛕 🦽 🦼 🛺 🪂 🪐 🤿 🪀 🪁 🦺 🥻 🩱 🩲 🩳 🩰 🪕 🪔 🪓 🦯 🩸 🩹 🩺 🪑 🪒 🤎 🤍 🟠 🟡 🟢 🟣 🟤 🟥 🟧 🟨 🟩 🟦 🟪 🟫
    }
    KeyboardKey {
        id: hideKey
        anchors.bottom: keyboard.bottom
        anchors.left: keyboard.left
        text: "⬇️"
        key: Qt.Key_unknown
        repeatOnHold: false
        onClick: keyboard.hide()
    }
    KeyboardKey {
        id: switchKey
        anchors.bottom: keyboard.bottom
        anchors.right: keyboard.right
        text: ["☺️","🔤"][page] || "ABC"
        key: Qt.Key_unknown
        repeatOnHold: false
        onClick: {
            page++;
            if(page < 0){
                page = 1;
            }else if(page > 1){
                page = 0;
            }
        }
    }
}