import QtQuick 2.9

Item {
    id: root

    signal hueChanged(real value)

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
            width: parent.width + grip.width

            Rectangle {
                x: -2;
                y: -height * 0.5
                width: root.width + 4;
                height: 11

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
                    color: "transparent"
                }
            }
            Rectangle {
                id: grip
                border.color: "black"
                border.width: 2
                height: 21
                width: height
                radius: 2

                x: root.width
                y: -height * 0.5

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

        MouseArea {
            anchors {
                fill: parent
                rightMargin: -grip.width
                topMargin: -grip.height / 2
                bottomMargin: -grip.height / 2
            }


            function handleMouse(mouse) {
                if (mouse.buttons & Qt.LeftButton) {
                    pickerCursor.y = Math.max(0, Math.min(height - grip.height, mouse.y))
                    root.hueChanged(1 - pickerCursor.y / (height - grip.height))
                }
            }
            onPositionChanged: handleMouse(mouse)
            onPressed: handleMouse(mouse)
        }
    }
}
