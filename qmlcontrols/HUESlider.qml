import QtQuick 2.9

Item {
    id: root

    signal hueColorChanged(real value)

    function restoreHue(hue) {
        pickerCursor.y = root.height * (1 - hue);
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 1.0;  color: "#ff0000" }
            GradientStop { position: 0.85; color: "#ffff00" }
            GradientStop { position: 0.76; color: "#00ff00" }
            GradientStop { position: 0.5;  color: "#00ffff" }
            GradientStop { position: 0.33; color: "#0000ff" }
            GradientStop { position: 0.16; color: "#ff00ff" }
            GradientStop { position: 0.0;  color: "#ff0000" }
        }
    }

    Item {
        anchors.fill: parent

        Item {
            id: pickerCursor
            width: parent.width

            Rectangle {
                x: -2;
                y: -height * 0.5
                width: root.width + 4;
                height: 7

                border.color: "White"
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
                    pickerCursor.y = Math.max(0, Math.min(height, mouse.y))
                    root.hueColorChanged(1 - pickerCursor.y / height)
                }
            }
            onPositionChanged: handleMouse(mouse)
            onPressed: handleMouse(mouse)
        }
    }
}
