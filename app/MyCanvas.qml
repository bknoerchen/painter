import QtQuick 2.0

import SymmetricCanvas 1.0

Item {
    SymmetricCanvas {
        id: myCanvas

        anchors.fill: parent

        property var lastPointById : ({})

        color: "white"
        penWidth: 5

        function paint(x, y, id) {
            drawShape(Qt.point(lastPointById[id].x, lastPointById[id].y), Qt.point(x, y));

            // update last point with coordinates of current point
            lastPointById[id].x = x;
            lastPointById[id].y = y;
        }
    }

    MultiPointTouchArea {
        id: multiTouchArea

        anchors.fill: parent

        onPressed: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];

                myCanvas.lastPointById[point.pointId] = {
                    x: point.x,
                    y: point.y
                }
            }
        }

        onUpdated: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                myCanvas.paint(point.x, point.y, point.pointId);
            }
        }

        onReleased: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                delete myCanvas.lastPointById[point.pointId]
            }
        }
    }
}
