import QtQuick 2.0
import QtQuick.Controls 2.0

import SymmetricCanvas 1.0

Item {
    anchors.fill: parent

    Component.onCompleted: {
        shapeSelector.currentIndex = 0;
        mirrorType.currentIndex = 0;
        myCanvas.symmetryCount = 20;
    }

    Row {
        id: controls

        height: 50

        ComboBox {
            id: symetryCountSelector

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            height: 20

            model: 50
            displayText: currentIndex + 1

            delegate: ItemDelegate {
                 text: index + 1
             }

            onCurrentIndexChanged: {
                myCanvas.symmetryCount = currentIndex + 1;
            }
        }

        ComboBox {
            id: shapeSelector

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 200

            textRole: "text"

            model: ListModel {
                id: shapeSelectorItems
                ListElement { text: "Polyline";  shape: "Polyline" }
                ListElement { text: "Rectangle"; shape: "Rectangle" }
                ListElement { text: "Ellipse";   shape: "Ellipse" }
            }

            onCurrentIndexChanged: {
                myCanvas.currentShape = shapeSelectorItems.get(currentIndex).shape;
            }
        }

        ComboBox {
            id: mirrorType

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 200
            height: 20

            textRole: "text"

            model: ListModel {
                id: mirrorTypeItems
                ListElement { text: "Keine";  mirrorType: ShapeMirrorType.MirrorOff }
                ListElement { text: "X-Axis"; mirrorType: ShapeMirrorType.MirrorOnX }
                ListElement { text: "Y-Axis"; mirrorType: ShapeMirrorType.MirrorOnY }
            }

            onCurrentIndexChanged: {
                console.log(mirrorTypeItems.get(currentIndex).mirrorType);
                myCanvas.mirrorType = mirrorTypeItems.get(currentIndex).mirrorType;
            }
        }

        Button {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            text: "Undo"

            onClicked: {
                myCanvas.undo();
            }
        }

        Button {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            text: "Redo"

            onClicked: {
                myCanvas.redo();
            }
        }


//        Component {
//            id: symmetryCountTumblerDelegate

//            Label {
//                color: "white"
//                text: modelData + 1
//                opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                font.pixelSize: fontMetrics.font.pixelSize * 1.25
//            }
//        }

//        Tumbler {
//            id: symmetryCountTumbler

//            width: 50
//            model: 20
//            delegate: symmetryCountTumblerDelegate
//            visibleItemCount: 5
//            currentIndex: 4

//            onCurrentIndexChanged: {
//                myCanvas.symmetryCount = currentIndex + 1;
//            }
//        }

    }

    Item {
        anchors {
            top: controls.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        SymmetricCanvas {
            id: myCanvas

            anchors.fill: parent

            color: "white"
            penWidth: 3
        }

        MultiPointTouchArea {
            id: multiTouchArea

            anchors.fill: parent

            onPressed: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i];
                    myCanvas.startPaint(Qt.point(point.x, point.y), point.pointId);
                }
            }

            onUpdated: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i];
                    myCanvas.updatePaint(Qt.point(point.x, point.y), point.pointId);
                }
            }

            onReleased: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i];
                    myCanvas.stopPaint(point.pointId);
                }
            }
        }
    }
}
