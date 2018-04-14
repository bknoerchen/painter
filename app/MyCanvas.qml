import QtQuick 2.0

import SymmetricCanvas 1.0

Item {
    SymmetricCanvas {
        id: myCanvas

        anchors.fill: parent

        color: "white"
        penWidth: 3
        currentShape: "Rectangle" // "Polyline"
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
