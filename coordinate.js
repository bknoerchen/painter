function Coordinate(x, y) {
    this.distance = function(coord) {
        return Math.sqrt(Math.pow(coord.x - this.x, 2) + Math.pow(coord.y - this.y, 2));
    }

    this.rotate = function(center, angle) {
        var radians = (Math.PI / 180) * angle;

        var cx = center.x;
        var cy = center.y;

        var calcCos = Math.cos(radians);
        var calcSin = Math.sin(radians);
        var nx = (calcCos * (this.x - cx)) + (calcSin * (this.y - cy)) + cx;
        var ny = (calcCos * (this.y - cy)) - (calcSin * (this.x - cx)) + cy;

        return new Coordinate(nx, ny);
    }

    this.yDistance = function(coord) {
        return coord.y - this.y;
    }

    this.xDistance = function(coord) {
        return coord.x - this.x;
    }

    this.log = function(id) {
        if (id) console.log("id:", id);
        console.log("(x,y)", x, y);
    }

    this.x = x;
    this.y = y;
    return this;
}

