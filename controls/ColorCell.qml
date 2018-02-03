import QtQuick 2.9

Rectangle {
    id: rectangle

    property int frameMargin: 3
    property bool isSelected: false

    signal checked()
    signal unchecked()

    height: 20
    width: height
    anchors.margins: 20

    Rectangle {
        visible: isSelected
        height: parent.height + 2 * frameMargin
        width: height
        x: -frameMargin
        y: -frameMargin
        color: "transparent"
        border {
            color: "white"
            width: 2
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (!isSelected) {
                rectangle.checked(color);
                isSelected = true;
            } else {
                rectangle.unchecked(color);
                isSelected = false;
            }
        }
    }

    function uncheck() {
        if (rectangle.isSelected) {
            isSelected = false;
        }
    }
}
