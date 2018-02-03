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

Point.prototype.log = function(id) {
    if (id) console.log("id:", id);
    console.log("(x,y)", x, y);
}
