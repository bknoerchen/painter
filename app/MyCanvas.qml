import QtQuick 2.0
import QtQuick.Controls 1.4

import SymmetricCanvas 1.0

Item {
    anchors.fill: parent

    ComboBox {
        id: shapeSelector

        anchors.top: parent.top
        width: 200
        height: 20

        currentIndex: 0
        model: ListModel {
            id: cbItems
            ListElement { text: "Polyline"; shape: "Polyline" }
            ListElement { text: "Rectangle"; shape: "Rectangle" }
        }
        onCurrentIndexChanged: {
            myCanvas.currentShape = cbItems.get(currentIndex).shape;
        }
    }

    Item {
        anchors {
            top: shapeSelector.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        SymmetricCanvas {
            id: myCanvas

            anchors.fill: parent

            color: "white"
            penWidth: 3
            currentShape: cbItems.get(cbItems.currentIndex).shape
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
