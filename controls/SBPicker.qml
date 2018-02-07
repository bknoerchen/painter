import QtQuick 2.9

import "colorutils.js" as ColorUtils

Item {
    id: root

    property real hueColor: 0

    signal sbChanged(real saturation,  real brightness)

    function restoreHSB(hsvHue, hsvSaturation, hsvValue) {
        console.log("restore", hsvSaturation, hsvValue);
        pickerCursor.x = width * hsvSaturation;
        pickerCursor.y = height * (1 - hsvValue);
        root.hueColor = hsvHue;
    }

    function hueColorChange(color) {
        hueColor = color
        root.sbChanged(pickerCursor.x/width, 1 - pickerCursor.y/height);
    }

    Rectangle {
        anchors.fill: parent;
        rotation: -90
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ffffff" }
            GradientStop { position: 1.0; color: ColorUtils.hsba(root.hueColor, 1.0, 1.0, 1.0, 1.0) }
        }
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#ff000000" }
            GradientStop { position: 0.0; color: "#00000000" }
        }
    }

    Item {
        id: pickerCursor
        property int r : 8

        Rectangle {
            x: -parent.r
            y: -parent.r
            width: parent.r * 2
            height: parent.r * 2
            radius: parent.r

            border.color: "white"
            border.width: 2
            color: "transparent"
        }
    }
    MouseArea {
        anchors {
            fill: parent
        }

        function handleMouse(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                pickerCursor.x = Math.max(0, Math.min(width,  mouse.x));
                pickerCursor.y = Math.max(0, Math.min(height, mouse.y));
                console.log("save", pickerCursor.x/width, 1 - pickerCursor.y/height);
                root.sbChanged(pickerCursor.x/width, 1 - pickerCursor.y/height)
            }
        }
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}
