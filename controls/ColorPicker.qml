import QtQuick 2.9

import QtQuick.Layouts 1.3

import "colorutils.js" as ColorUtils

GridLayout {
    id: root

    property int globalSpacing: 5
    property alias predefinedColors: predefinedColors.colors

    signal colorChanged(color rgbColor)
    rows: 2
    flow: GridLayout.LeftToRight
    columns: 2

    SBPicker {
        id: sbPicker

        Layout.margins: globalSpacing

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.minimumHeight: predefinedColors.width + globalSpacing
        Layout.preferredHeight: 300
        Layout.maximumHeight: 500

        Layout.minimumWidth: predefinedColors.width + globalSpacing
        Layout.preferredWidth: 300
        Layout.maximumWidth: 500

        onSbChanged: {
            var colorValue = ColorUtils.hsba(hueColor, saturation, brightness, 1)
            predefinedColors.setColor(ColorUtils.fullColorString(colorValue, 1));
        }
    }

    HUESlider {
        id: hueSlider

        Layout.margins: globalSpacing

        Layout.fillHeight: true
        Layout.fillWidth: false

        Layout.preferredHeight: 200
        Layout.maximumHeight: 500

        Layout.preferredWidth: predefinedColors.height
        Layout.maximumWidth: predefinedColors.height

        Component.onCompleted: {
            hueSlider.hueColorChanged.connect(sbPicker.hueColorChange);
        }
    }

    Item {

        Layout.margins: globalSpacing
        Layout.columnSpan: 2
        Layout.minimumHeight: predefinedColors.height
        Layout.preferredHeight: predefinedColors.height
        Layout.maximumHeight: predefinedColors.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }

            height: predefinedColors.height
            width: predefinedColors.width + currentColorChosen.width

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
                    currentColorChosen.color = color
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
                                currentColorChosen.color = color;

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
                    id: currentColorChosen

                    anchors {
                        left: predefinedColors.right
                        leftMargin: root.globalSpacing * 4
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
    }
}

