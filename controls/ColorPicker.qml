import QtQuick 2.9

import QtQuick.Layouts 1.3

import "colorutils.js" as ColorUtils

Item {
    id: root

    property int globalSpacing: 10

    signal colorChanged(color rgbColor)
    signal enableTouchChangeColor(var colorArray)

    ColumnLayout {
        spacing: globalSpacing

        Item{
            Layout.alignment: Qt.AlignCenter

            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            RowLayout {
                id: layout
                anchors.fill: parent
                spacing: globalSpacing

                SBPicker {
                    id: sbPicker

                    Layout.fillWidth: true
                    Layout.minimumWidth: 100
                    Layout.preferredWidth: 200
                    Layout.maximumWidth: 300

                    Layout.minimumHeight: width
                    Layout.preferredHeight: width
                    Layout.maximumHeight: width

                    onSbChanged: {
                        var colorValue = ColorUtils.hsba(hueColor, saturation, brightness, 1)
                        predefinedColors.setColor(ColorUtils.fullColorString(colorValue, 1));
                    }
                }

                HUESlider {
                    id: hueSlider

                    Layout.fillWidth: false
                    Layout.minimumWidth: 20
                    Layout.preferredWidth: 20
                    Layout.maximumWidth: 20

                    Layout.minimumHeight: sbPicker.height
                    Layout.preferredHeight: sbPicker.height
                    Layout.maximumHeight: sbPicker.height

                    Component.onCompleted: {
                        hueSlider.hueColorChanged.connect(sbPicker.hueColorChange);
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }

        //////

        Item {
            Layout.alignment: Qt.AlignCenter

            Layout.preferredWidth: 200
            Layout.preferredHeight: predefinedColors.height

            Item {
                id : predefinedColors

                property int itemHeight: 20
                property int itemFrameMargin: 3
                property int cellRowCount: 2
                property int cellColumnCount: 5
                property int cellSpacing: 10
                property int currentIndex: -1

                property var colors: [
                    "#00bfff",
                    "#ff69b4",
                    "#f0e68c",
                    "#add8e6",
                    "#ffa07a",
                    "#9370db",
                    "#98fb98",
                    "#dda0dd",
                    "#ff6347",
                    "#40e0d0"
                ]

                function setColor(color) {
                    if (currentIndex > -1) {
                        predefinedColorsRepeater.itemAt(currentIndex).color = color;
                        predefinedColors.colors[currentIndex] = color;
                    }
                    currentColorChoosen.color = color
                }

                height: (cellRowCount - 1) * cellSpacing + cellRowCount * itemHeight
                width: (cellColumnCount - 1) * cellSpacing + cellColumnCount * itemHeight

                Grid {
                    id : predefinedColorsGrid

                    signal uncheckOtherCells();

                    anchors.fill: parent
                    columns: predefinedColors.cellColumnCount
                    rows: predefinedColors.cellRowCount
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    spacing: predefinedColors.cellSpacing

                    Repeater {
                        id: predefinedColorsRepeater

                        model: predefinedColors.cellRowCount * predefinedColors.cellColumnCount

                        delegate: ColorCell {
                            color: predefinedColors.colors[index]
                            height: predefinedColors.itemHeight
                            frameMargin: predefinedColors.itemFrameMargin

                            onChecked: {
                                predefinedColorsGrid.uncheckOtherCells();
                                currentColorChoosen.color = color;

                                sbPicker.restoreHSB(color.hsvHue, color.hsvSaturation, color.hsvValue);
                                hueSlider.restoreHue(color.hsvHue);

                                predefinedColors.currentIndex = index
                            }
                            onUnchecked: {
                                predefinedColors.currentIndex = -1
                            }

                            Component.onCompleted: {
                                predefinedColorsGrid.uncheckOtherCells.connect(uncheck);
                            }
                        }
                    }
                }

                Rectangle {
                    id: currentColorChoosen

                    anchors {
                        left: predefinedColors.right
                        leftMargin: predefinedColors.cellSpacing
                    }

                    onColorChanged: {
                        root.colorChanged(color);
                    }

                    height: predefinedColors.height
                    width: height

                    color: "white"
                }
            }
        }

        //////

        Item {
            Layout.alignment: Qt.AlignCenter

            Layout.preferredWidth: 200
            Layout.preferredHeight: 10

            SwitchButton {
                text: qsTr("touch changes color")
                checked: true

                onCheckedChanged: {
                    root.enableTouchChangeColor(checked ? predefinedColors.colors : [])
                }
            }
        }
    }
}
