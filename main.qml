import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

import "coordinate.js" as MyPainter

ApplicationWindow {
    id: mainWindow

    title: qsTr("Paint")
    width: 640
    height: 480
    visible: true

    Rectangle {
        anchors.fill: parent
        color: "black"

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
                left: parent.left
                bottom: saveButton.top
            }

            width: 40
            model: 10
            delegate: delegateComponent
            visibleItemCount: 7
            currentIndex: 4

            onCurrentIndexChanged: {
                myCanvas.edges = currentIndex + 1;
            }

        }

        Connections {
            target: _androidFileDialog
            onImageHomeChanged: {

                console.log("-----------------------------", _androidFileDialog.imageHome);
            }
        }

        Button {
            id: saveButton
            anchors {
                left: parent.left
                bottom: clearButton.top
            }

            text: "S"
            width: 40
            height:40

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    _androidFileDialog.searchImage();



                    myCanvas.save("MyMandala.png");
                }
            }
        }

        Button {
            id: clearButton
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            text: "C"
            width: 40
            height:40

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    myCanvas.clearCanvas();
                }
            }
        }

        Canvas {
            id: myCanvas

            anchors {
                top: parent.top
                left: edgeTumbler.right
                bottom: parent.bottom
                right: parent.right
            }

            property var center: new MyPainter.Coordinate(width / 2, height / 2)
            property int radius: Math.min(center.x, center.y)

            antialiasing: true
            renderTarget: Canvas.Image

            property var lastPosById
            property var posById
            property var pointPath

            property int edges

            property int colorIndex: 0

            property string pathString: ""

            property var colors: [
                "#00BFFF",
                "#FF69B4",
                "#F0E68C",
                "#ADD8E6",
                "#FFA07A",
                "#9370DB",
                "#98FB98",
                "#DDA0DD",
                "#FF6347",
                "#40E0D0"

            ]

            function clearCanvas() {
                var ctx = getContext("2d");
                ctx.reset();
                myCanvas.requestPaint();
            }

            onPaint: {
                var ctx = getContext('2d')
                if (lastPosById === undefined) {
                    lastPosById = {}
                    posById = {}
                    pointPath = []
                }

                for (var id in lastPosById) {

                    var disLastPos = center.distance(lastPosById[id].coordiantes);
                    if (disLastPos > radius) {
                        var angle = Math.asin(center.yDistance(lastPosById[id].coordiantes) / disLastPos);
                        var xSign = center.xDistance(lastPosById[id].coordiantes) < 0 ? -1 : 1;

                        lastPosById[id].coordiantes = new MyPainter.Coordinate(
                                    myCanvas.center.x + xSign * Math.cos(angle) * radius,
                                    myCanvas.center.y + xSign * xSign * Math.sin(angle) * radius)
                    }

                    var disPos = center.distance(posById[id].coordiantes);
                    if (disPos > radius) {
                        var angle = Math.asin(center.yDistance(posById[id].coordiantes) / disPos);
                        var xSign = center.xDistance(posById[id].coordiantes) < 0 ? -1 : 1;

                        posById[id].coordiantes = new MyPainter.Coordinate(
                                    myCanvas.center.x + xSign * Math.cos(angle) * radius,
                                    myCanvas.center.y + xSign * xSign * Math.sin(angle) * radius)
                    }

                    ctx.strokeStyle = colors[(colorIndex + parseInt(id, 10)) % colors.length]
                    var deltaAngle = 360 / myCanvas.edges;
                    var startPoint = lastPosById[id].coordiantes;
                    var endPoint = posById[id].coordiantes;

                    for (var i = 0; i < myCanvas.edges; i++) {
                        ctx.beginPath()
                        ctx.moveTo(startPoint.x, startPoint.y)
                        ctx.lineTo(endPoint.x, endPoint.y)
                        ctx.stroke()

                        startPoint = startPoint.rotate(center, deltaAngle);
                        endPoint = endPoint.rotate(center, deltaAngle);
                    }


                    // update lastpos
                    lastPosById[id] = posById[id]
                }
            }

            MultiPointTouchArea {
                anchors.fill: parent

                onPressed: {
                    for (var i = 0; i < touchPoints.length; ++i) {
                        var point = touchPoints[i]
                        // update both so we have data
                        myCanvas.lastPosById[point.pointId] = {
                            coordiantes: new MyPainter.Coordinate(point.x, point.y)
                        }
                        myCanvas.posById[point.pointId] = {
                            coordiantes: new MyPainter.Coordinate(point.x, point.y)
                        }
                    }
                }
                onUpdated: {
                    for (var i = 0; i < touchPoints.length; ++i) {
                        var point = touchPoints[i]
                        // only update current pos, last update set on paint
                        myCanvas.posById[point.pointId] = {
                            coordiantes: new MyPainter.Coordinate(point.x, point.y)
                        }
                    }
                    myCanvas.requestPaint()
                }
                onReleased: {
                    for (var i = 0; i < touchPoints.length; ++i) {
                        var point = touchPoints[i]
                        delete myCanvas.lastPosById[point.pointId]
                        delete myCanvas.posById[point.pointId]
                    }
                    myCanvas.colorIndex++
                    if (myCanvas.colorIndex > (myCanvas.colors.length - 1)) myCanvas.colorIndex = 0;
                }
            }
        }

    }
}
