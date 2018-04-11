import QtQuick 2.0

import PainterCanvas 1.0

import "point.js" as JsCanvas

Item {
    PainterCanvas {
        id: myCanvas

        anchors.fill: parent

        signal paint();

        property var lastPosById : ({})
        property var posById : ({})

        color: "green"

//        onPaint: {
//            if (lastPosById === undefined) {
//                lastPosById = {}
//                posById = {}
//            }
//        }
    }

    MultiPointTouchArea {
        anchors.fill: parent

        onPressed: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                myCanvas.lastPosById[point.pointId] = {
                    coordiantes: new JsCanvas.Point(point.x, point.y)
                }
                myCanvas.posById[point.pointId] = {
                    coordiantes: new JsCanvas.Point(point.x, point.y)
                }
            }
        }
        onUpdated: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var point = touchPoints[i];
                // only update current pos, last update set on paint
                myCanvas.posById[point.pointId] = {
                    coordiantes: new JsCanvas.Point(point.x, point.y)
                }
                //myCanvas.requestPaint()
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
