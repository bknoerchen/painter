import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import "controls"

ApplicationWindow {
    id: mainWindow

    title: qsTr("Paint")
    width: Screen.width
    height: Screen.height
    color: "black"
    visible: true

    header: ToolBar {
        id: header

        background: Rectangle {
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "#ff404244" }
            }
        }

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: stackView.depth > 1 ? "qrc:/images/back.png" : "qrc:/images/drawer.png"
                }
                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop();
                        drawer.close();
                    } else {
                        drawer.open();
                    }
                }
            }

            Label {
                id: titleLabel
                text: "Painter"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Settings"
                        onTriggered: settingsDialog.open()
                    }
                    MenuItem {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer

        width: mainWindow.width * 0.8
        height: mainWindow.height - header.height
        y: header.height

        //interactive: false //stackView.depth === 1

        Rectangle {
            anchors.fill: parent

            color: "#3E4042"

            Column {

                anchors {
                    fill: parent
                    leftMargin: 10
                }

                ColorPicker {
                    height: 310;
                    width: 300;

                    onColorChanged: {
                        canvas.lineColor = rgbColor;
                    }

                    onEnableTouchChangeColor: {
                        console.log(colorArray);
                        canvas.lineColors = colorArray;
                    }
                }


                SwitchButton {
                    height: 45
                    width: 300
                    text: qsTr("mirror on x-axis")
                    checked: true

                    onCheckedChanged: {
                        canvas.mirrorOnX = checked
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: PainterCanvas {
            id: canvas
            anchors.fill: parent
        }

 //           Pane {
 //           id: pane

//            Image {
//                id: logo
//                width: pane.availableWidth / 2
//                height: pane.availableHeight / 2
//                anchors.centerIn: parent
//                anchors.verticalCenterOffset: -50
//                fillMode: Image.PreserveAspectFit
//                source: "images/qt-logo.png"
//            }

//            Label {
//                text: "Painting"
//                anchors.margins: 20
//                anchors.top: parent.bottom
//                anchors.left: parent.left
//                anchors.right: parent.right
//                horizontalAlignment: Label.AlignHCenter
//                verticalAlignment: Label.AlignVCenter
//                wrapMode: Label.Wrap
//            }

//            Image {
//                id: arrow
//                source: "images/arrow.png"
//                anchors.left: parent.left
//                anchors.bottom: parent.bottom
//            }


    }


}
