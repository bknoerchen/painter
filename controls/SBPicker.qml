import QtQuick 2.9

import "colorutils.js" as ColorUtils

Item {
    id: root
    property real hueColor: 0

    onHueColorChanged: {
        root.sbChanged(pickerCursor.x/width, 1 - pickerCursor.y/(height - grip.height/2 - pickerCursor.r));
    }

    signal sbChanged(real saturation,  real brightness)

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

            border.color: "black"
            border.width: 2
            color: "transparent"

            Rectangle {
                anchors {
                    fill: parent
                    margins: 2
                }
                border.color: "white"
                border.width: 2
                radius: width/2
                color: "transparent"
            }
            Rectangle {
                id: grip

                border.color: "black"
                border.width: 2
                height: 21
                width: height
                radius: 2

                x: -3
                y: pickerCursor.r * 2 - 1

                Image {
                    anchors {
                        fill: parent
                        margins: 2
                    }
                    source: "qrc:/images/grip.png"
                    fillMode: Image.Tile
                }
            }
        }
    }
    MouseArea {
        anchors {
            fill: parent
            bottomMargin: -grip.height/2 - pickerCursor.r
        }

        function handleMouse(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                pickerCursor.x = Math.max(0, Math.min(width,  mouse.x));
                pickerCursor.y = Math.max(0, Math.min(height - grip.height/2 - pickerCursor.r, mouse.y - grip.y));
                root.sbChanged(pickerCursor.x/width, 1 - pickerCursor.y/(height - grip.height/2 - pickerCursor.r))
            }
        }
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}
