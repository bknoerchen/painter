import QtQuick 2.0

import SymmetricCanvas 1.0

Item {
    SymmetricCanvas {
        id: myCanvas

        anchors.fill: parent

        signal paint();

        property var lastPosById : ({})
        property var posById : ({})

        color: "white"
        penWidth: 5

        onPaint: {
            var startPoint;
            var endPoint;

            for (var id in lastPosById) {
                startPoint = lastPosById[id];
                endPoint = posById[id];

                console.log("startPoint", startPoint.x, startPoint.y);
                console.log("endPoint", endPoint.x, endPoint.y);

                drawShape(Qt.point(startPoint.x, startPoint.y), Qt.point(endPoint.x, endPoint.y));

                // update lastpos
                lastPosById[id].x = posById[id].x;
                lastPosById[id].y = posById[id].y;
            }
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent

        onPressed: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                myCanvas.lastPosById[point.pointId] = {
                    x: point.x,
                    y: point.y
                }
                myCanvas.posById[point.pointId] = {
                    x: point.x,
                    y: point.y
                }
            }
        }
        onUpdated: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                // only update current pos, last update set on paint
                myCanvas.posById[point.pointId] = {
                    x: point.x,
                    y: point.y
                }
                myCanvas.paint();
            }
        }
        onReleased: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                delete myCanvas.lastPosById[point.pointId]
                delete myCanvas.posById[point.pointId]
            }
        }
    }
}
