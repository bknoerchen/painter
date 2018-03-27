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

        width: parent.width * 0.95
        height: mainWindow.height - header.height
        y: header.height

        //interactive: false //stackView.depth === 1

        Rectangle {
            id: drawerContainer
            anchors.fill: parent

            color: "#3E4042"

            Flow {
                anchors {
                    fill: parent
                    margins: 10
                }
                width: drawerContainer.width

                ColorPicker {
                    id: colorPicker

                    width: Math.max(drawer.width * 0.4, 60)
                    height: Math.max(drawer.width * 0.4, 60)

                    onColorChanged: {
                        canvas.lineColor = rgbColor;
                    }
                }

                Column {
                    SwitchButton {
                        height: 45
                        width: 300
                        checked: true
                        text: qsTr("touch changes color")

                        onCheckedChanged: {
                            canvas.lineColors = checked ? colorPicker.predefinedColors : [];
                        }
                    }

                    SwitchButton {
                        height: 45
                        width: 300
                        text: qsTr("mirror on y-axis")
                        checked: true

                        onCheckedChanged: {
                            canvas.mirrorOnX = checked
                        }
                    }

                    SwitchButton {
                        height: 45
                        width: 300
                        text: qsTr("capture lines in circle")
                        checked: true

                        onCheckedChanged: {
                            canvas.captureLinesInCircle = checked
                        }
                    }

                    SwitchButton {
                        height: 45
                        width: 300
                        text: qsTr("blur on")
                        checked: false

                        onCheckedChanged: {
                            canvas.blurActivated = checked
                        }
                    }

                    SwitchButton {
                        height: 45
                        width: 300
                        text: qsTr("enable floodfill")
                        checked: false

                        onCheckedChanged: {
                            canvas.floodFillEnabled = checked
                        }
                    }

                    SwitchButton {
                        height: 45
                        width: 300
                        text: qsTr("enable rainbow color")
                        checked: false

                        onCheckedChanged: {
                            canvas.rainbowColorEnabled = checked
                        }
                    }
                }
            }

            Rectangle {
                id: edgeTumblerContainer

                height: drawerContainer.height
                anchors {
                    right: parent.right
                    rightMargin: 2
                }
                width: 40;

                color: "#2F3334"

                FontMetrics {
                    id: fontMetrics
                }

                Component {
                    id: delegateComponent

                    Label {
                        color: "white"
                        text: modelData + 1
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: fontMetrics.font.pixelSize * 1.25
                    }
                }

                Tumbler {
                    id: edgeTumbler

                    anchors {
                        top: parent.top
                        bottom: saveButton.top
                    }

                    width: 40
                    model: 10
                    delegate: delegateComponent
                    visibleItemCount: 5
                    currentIndex: 4

                    onCurrentIndexChanged: {
                        canvas.edges = currentIndex + 1;
                    }
                }

                Item {
                    height: edgeTumbler.height / edgeTumbler.visibleItemCount
                    width: edgeTumbler.width
                    y: height * (edgeTumbler.visibleItemCount - 1) / 2
                    x: edgeTumbler.y

                    Rectangle {
                        anchors {
                            fill: parent
                            leftMargin: -5
                            rightMargin: -5
                        }

                        color: "transparent"
                        border {
                            color: "white"
                            width: 2
                        }
                    }
                }

                //    Connections {
                //        target: _androidFileDialog
                //        onImageHomeChanged: {

                //            console.log("-----------------------------", _androidFileDialog.imageHome);
                //        }
                //    }

                Button {
                    id: saveButton
                    anchors {
                        bottom: clearButton.top
                    }

                    btnText: "S"
                    width: 40
                    height:40

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //_androidFileDialog.searchImage();
                            colorDialog.visible = true


                            myCanvas.save("MyMandala.png");
                        }
                    }
                }

                Button {
                    id: clearButton
                    anchors {
                        bottom: parent.bottom
                    }

                    btnText: "C"
                    width: 40
                    height:40

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            canvas.clearCanvas();
                        }
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
