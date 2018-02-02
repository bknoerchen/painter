function Coordinate(x, y) {
    this.x = x;
    this.y = y;
    this.radians = (Math.PI / 180);
}

Coordinate.prototype.distance = function(coord) {
    var dx = coord.x - this.x;
    var dy = coord.y - this.y;
    return Math.sqrt(dx * dx + dy * dy);
}

Coordinate.prototype.rotate = function(center, angle) {
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

Coordinate.prototype.yDistance = function(coord) {
    return coord.y - this.y;
}

Coordinate.prototype.xDistance = function(coord) {
    return coord.x - this.x;
}

Coordinate.prototype.log = function(id) {
    if (id) console.log("id:", id);
    console.log("(x,y)", x, y);
}

