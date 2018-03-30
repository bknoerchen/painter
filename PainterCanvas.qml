import QtQuick 2.9
import QtQuick.Controls 2.2

import "point.js" as CanvasTools
import "controls/colorutils.js" as ColorUtils

Rectangle {
    id: root

    property alias edges: myCanvas.edges

    signal clearCanvas()

    anchors.fill: parent
    color: "black"

    property color lineColor: "#ffffff"
    property var lineColors: [
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

    property var rainbowColors: [
        "#FF0000",
        "#E2571E",
        "#FF7F00",
        "#FFFF00",
        "#00FF00",
        "#96bf33",
        "#0000FF",
        "#4B0082",
        "#8B00FF",
        "#ffffff"
    ]

    property bool mirrorOnX: true
    property bool captureLinesInCircle: true
    property bool blurActivated: false
    property bool floodFillEnabled: false
    property bool rainbowColorEnabled: false

    Canvas {
        id: myCanvas

        property var center: new CanvasTools.Point(width / 2, height / 2)
        property int radius: Math.min(center.x, center.y)

        property var lastPosById
        property var posById
        property var pointPath

        property int edges

        property int colorIndex: 0
        property int rainbowColorIndex: 0
        property int rainbowColorIntervalCounter: 0

        // number of different colors (min 6, max 360)
        property int rainbowColorIndexStep: 360 / 60

        // how many strokes till color changes (min 1, rainbowColorIndexStep * 5)
        property int rainbowColorIntervalLength: rainbowColorIndexStep * 1

        property int hue: 0

        property string pathString: ""

        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.Image

        function clearCanvas() {
            var ctx = getContext("2d");
            ctx.reset();
            myCanvas.requestPaint();
        }

        Component.onCompleted: {
            root.clearCanvas.connect(clearCanvas);
        }

        onPaint: {
            var angle;
            var xSign;
            var startPoint;
            var endPoint;
            var ctx = getContext('2d');
            if (lastPosById === undefined) {
                lastPosById = {}
                posById = {}
                pointPath = []
            }

            for (var id in lastPosById) {
                var currentColor = rainbowColorEnabled
                        ? ColorUtils.colorFromHue((rainbowColorIndex + ((parseInt(id, 10) % rainbowColorIndexStep) * (360 / rainbowColorIndexStep))) % 360)     //root.rainbowColors[(rainbowColorIndex + parseInt(id, 10)) % root.rainbowColors.length]
                        : (root.lineColors.length > 0 ?
                               root.lineColors[(colorIndex + parseInt(id, 10)) % root.lineColors.length] :
                               root.lineColor);

                if (floodFillEnabled) {
                    //var imageData = canvas.toImage(0, 0, canvas.width, canvas.height);
                    ctx.lineWidth = 3;
                    var k = ctx.getImageData(0, 0, 10, 10);
                    _cppController.floodFill(k.data[0], k.data[k.length - 4],
                                             currentColor,
                                             lastPosById[id].coordiantes.x,
                                             lastPosById[id].coordiantes.y,
                                             10,
                                             10);
                } else {

                    var disLastPos = center.distance(lastPosById[id].coordiantes);
                    if (disLastPos > radius && captureLinesInCircle) {
                        angle = Math.asin(center.yDistance(lastPosById[id].coordiantes) / disLastPos);
                        xSign = center.xDistance(lastPosById[id].coordiantes) < 0 ? -1 : 1;

                        lastPosById[id].coordiantes.x = myCanvas.center.x + xSign * Math.cos(angle) * radius;
                        lastPosById[id].coordiantes.y = myCanvas.center.y + Math.sin(angle) * radius;
                    }

                    var disPos = center.distance(posById[id].coordiantes);
                    if (disPos > radius && captureLinesInCircle) {
                        angle = Math.asin(center.yDistance(posById[id].coordiantes) / disPos);
                        xSign = center.xDistance(posById[id].coordiantes) < 0 ? -1 : 1;

                        posById[id].coordiantes.x = myCanvas.center.x + xSign * Math.cos(angle) * radius;
                        posById[id].coordiantes.y = myCanvas.center.y + Math.sin(angle) * radius;
                    }

                    ctx.lineWidth = 3;
                    //context.strokeStyle = 'rgb(' + currentColor.red + ', ' + currentColor.green + ', ' + currentColor.blue + '/*, 50%, 50%*/)';
                    if (blurActivated) {
                        ctx.shadowColor = currentColor;
                        ctx.shadowBlur = context.lineWidth * 2;
                    }
                    ctx.strokeStyle = currentColor;
                    var deltaAngle = 360 / myCanvas.edges;
                    startPoint = lastPosById[id].coordiantes;
                    endPoint = posById[id].coordiantes;

                    for (var i = 0; i < myCanvas.edges; i++) {
//                        ctx.beginPath()
//                        ctx.moveTo(startPoint.x, startPoint.y)
//                        ctx.lineTo(endPoint.x, endPoint.y)
//                        ctx.stroke()
                        _cppController.paintWithHistory(myCanvas, startPoint.x, startPoint.y, endPoint.x, endPoint.y, 5, currentColor);

                        startPoint.rotate(center, deltaAngle);
                        endPoint.rotate(center, deltaAngle);
                    }

                    startPoint = lastPosById[id].coordiantes;
                    endPoint = posById[id].coordiantes;
                    if (mirrorOnX) {
                        for (i = 0; i < myCanvas.edges; i++) {
                            ctx.beginPath()
                            ctx.moveTo(2 * center.x - startPoint.x , startPoint.y)
                            ctx.lineTo(2 * center.x - endPoint.x, endPoint.y)
                            ctx.stroke()

                            startPoint.rotate(center, deltaAngle);
                            endPoint.rotate(center, deltaAngle);
                        }
                    }


                    // update lastpos
                    lastPosById[id] = posById[id]
                }
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent

            onPressed: {
                for (var i = 0; i < touchPoints.length; ++i) {
                    var point = touchPoints[i];
                    console.log("....", point.pointId)
                    // update both so we have data
                    myCanvas.lastPosById[point.pointId] = {
                        coordiantes: new CanvasTools.Point(point.x, point.y)
                    }
                    myCanvas.posById[point.pointId] = {
                        coordiantes: new CanvasTools.Point(point.x, point.y)
                    }
                }
                if (floodFillEnabled) {
                    myCanvas.requestPaint()
                    if (root.lineColors.length > 0) {
                        myCanvas.colorIndex++;
                        myCanvas.colorIndex %= root.lineColors.length;
                    }
                }
            }
            onUpdated: {
                if (!floodFillEnabled) {
                    for (var i = 0; i < touchPoints.length; ++i) {
                        var point = touchPoints[i];
                        // only update current pos, last update set on paint
                        myCanvas.posById[point.pointId] = {
                            coordiantes: new CanvasTools.Point(point.x, point.y)
                        }
                    }

                    myCanvas.rainbowColorIntervalCounter++;
                    if (rainbowColorEnabled && (myCanvas.rainbowColorIntervalCounter % myCanvas.rainbowColorIntervalLength == 0)) {
                        //myCanvas.rainbowColorIndex++;
                        //myCanvas.rainbowColorIndex %= root.rainbowColors.length;
                        myCanvas.rainbowColorIndex +=  myCanvas.rainbowColorIndexStep;
                        myCanvas.rainbowColorIndex %= 360;
                    }
                    myCanvas.requestPaint()
                }
            }
            onReleased: {
                if (!floodFillEnabled) {
                    for (var i = 0; i < touchPoints.length; ++i) {
                        var point = touchPoints[i];
                        delete myCanvas.lastPosById[point.pointId]
                        delete myCanvas.posById[point.pointId]
                    }
                    if (root.lineColors.length > 0) {
                        myCanvas.colorIndex++;
                        myCanvas.colorIndex %= root.lineColors.length;
                    }
                }
            }
        }
    }

}
