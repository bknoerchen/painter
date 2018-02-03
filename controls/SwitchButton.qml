import QtQuick 2.9

import QtQuick.Controls 2.1

Switch {
    id: root

    property color enabledColor: "#17a81a"
    property color disabledColor: "black"
    property color switchColor: "white"
    property color textColor: "white"

    text: ""

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 26
        x: root.leftPadding
        y: parent.height / 2 - height / 2
        radius: implicitHeight / 2
        color: root.checked ? root.enabledColor : root.disabledColor
        //border.color: control.checked ? "#17a81a" : "#cccccc"

        Rectangle {
            property int borderPadding: (parent.height - height) / 2
            height: 22
            width: height
            x: root.checked ? parent.width - width - borderPadding : borderPadding
            y: borderPadding
            radius: height / 2
            color: root.switchColor
            //border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
        }
    }

    contentItem: Text {
        text: root.text
        font: root.font
        opacity: enabled ? 1.0 : 0.3
        color: root.textColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: root.indicator.width + root.spacing
    }
}
