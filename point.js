function Point(x, y) {
    this.x = x;
    this.y = y;
    this.radians = (Math.PI / 180);
}

Point.prototype.distance = function(point) {
    var dx = point.x - this.x;
    var dy = point.y - this.y;
    return Math.sqrt(dx * dx + dy * dy);
}

Point.prototype.rotate = function(center, angle) {
    var radians = this.radians * angle;

    var cx = center.x;
    var cy = center.y;

    var dx = this.x - cx;
    var dy = this.y - cy;

    var calcCos = Math.cos(radians);
    var calcSin = Math.sin(radians);

    var nx = (calcCos * dx) + (calcSin * dy) + cx;
    var ny = (calcCos * dy) - (calcSin * dx) + cy;

    this.x = nx;
    this.y = ny;
}

Point.prototype.yDistance = function(point) {
    return point.y - this.y;
}

Point.prototype.xDistance = function(point) {
    return point.x - this.x;
}

Point.prototype.isInRange = function(max)
{
    var retval =
    (
        this.x >= 0
        && this.x <= max.x
        && this.y >= 0
        && this.y <= max.y
    );
    return retval;
}

Point.prototype.clone = function()
{
    return new Point(this.x, this.y);
}

Point.prototype.overwriteWith = function(other)
{
    this.x = other.x;
    this.y = other.y;
    return this;
}

Point.prototype.add = function(other)
{
    this.x += other.x;
    this.y += other.y;
    return this;
}

Point.prototype.log = function(id) {
    if (id) console.log("id:", id);
    console.log("(x: " + x + "y: " + y);
}

//////////////////////////////////////////////////

function hexToRgb(hexColor) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hexColor.toString());
    return result ? {
        red: parseInt(result[1], 16),
        green: parseInt(result[2], 16),
        blue: parseInt(result[3], 16)
    } : null;
}

function floodFill(ctx, pixelPos, color, colorDifferenceTolerance)
{
    var pixelRGBAMaster = ctx.getImageData(pixelPos.x, pixelPos.y, 1, 1).data;
    console.log(pixelRGBAMaster[0], pixelRGBAMaster[1], pixelRGBAMaster[2]);

    ctx.beginPath()
    if (!colorDifferenceTolerance) {
        colorDifferenceTolerance = 1;
    }

    ctx.strokeStyle = color;
    ctx.fillStyle = color;

    var colorToFillOverRGBA = hexToRgb(color)

    var imageSize = new Point(ctx.canvas.width, ctx.canvas.height);

    // save 'flat' index of start pixel
    var pixelIndicesToTest = [pixelPos.y * imageSize.x + pixelPos.x];
    var pixelIndicesAlreadyTested = [];

    var neighborOffsets = [
                new Point(-1, 0),
                new Point(1, 0),
                new Point(0, -1),
                new Point(0, 1)
            ];

    while (pixelIndicesToTest.length > 0) {
        var pixelIndex = pixelIndicesToTest.pop();
        pixelIndicesAlreadyTested[pixelIndex] = pixelIndex;

        // build point from flat index
        pixelPos.x = pixelIndex % imageSize.x;
        pixelPos.y = Math.floor(pixelIndex / imageSize.x);

        // get color of current pixel
        var pixelRGBA = ctx.getImageData(pixelPos.x, pixelPos.y, 1, 1).data;

        // calculate color difference from fill color to current color of pixel
        var pixelColorDifference = Math.abs(pixelRGBA[0] - colorToFillOverRGBA.red +
                                            pixelRGBA[1] - colorToFillOverRGBA.green +
                                            pixelRGBA[2] - colorToFillOverRGBA.blue);

        // just do smth if we are in tolerance range, otherwise the color differs to mutch
        console.log(pixelRGBAMaster[0], pixelRGBA[0]);
        if ((pixelRGBAMaster[0] === pixelRGBA[0]) &&
                (pixelRGBAMaster[1] === pixelRGBA[1]) &&
                (pixelRGBAMaster[2] === pixelRGBA[2])) {//(pixelColorDifference <= colorDifferenceTolerance) {
            // overwrite current color at point

            ctx.rect(pixelPos.x, pixelPos.y, 1, 1)
            ctx.fill();

            var neighborPos = new Point();

            for (var n = 0, nLen = neighborOffsets.length; n < nLen; n++) {
                var neighborOffset = neighborOffsets[n];

                // calculate neighbor point
                neighborPos.overwriteWith(pixelPos).add(neighborOffset);

                // neighbor is on canvas
                if (neighborPos.isInRange(imageSize) === true) {
                    // claculate flat index
                    var neighborIndex = neighborPos.y * imageSize.x + neighborPos.x;

                    // neighbor is not allready queued for testing
                    if (pixelIndicesToTest.indexOf(neighborIndex) === -1 && pixelIndicesAlreadyTested[neighborIndex] === undefined) {
                        pixelIndicesToTest.push(neighborIndex);
                    }
                }
            }
        }
    }
}


