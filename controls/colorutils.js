//  Color manipulation utilities

//  creates color value from hue, saturation, brightness, alpha
function hsba(h, s, b, a) {
    var lightness = (2 - s)*b;
    var satHSL = s*b/((lightness <= 1) ? lightness : 2 - lightness);
    return Qt.hsva(h, satHSL, lightness, a);
}

//  creates a full color string from color value and alpha[0..1], e.g. "#ff00ff00"
function fullColorString(clr, a) {
    return "#" + ((Math.ceil(a*255) + 256).toString(16).substr(1, 2) +
                  clr.toString().substr(1, 6)).toUpperCase();
}

function colorString(clr) {
    return "#" + (clr.toString().substr(1, 6)).toUpperCase();
}

//  extracts integer color channel value [0..255] from color value
function getChannelStr(clr, channelIdx) {
    return parseInt(clr.toString().substr(channelIdx*2 + 1, 2), 16);
}

function colorFromHue(hue) {
    var h = hue/60;
    var c = 255;
    var x = (1 - Math.abs(h%2 - 1))*255;
    var color;

    var i = Math.floor(h);

    if (i == 0) color = rgbToHex(c, x, 0);
    else if (i == 1) color = rgbToHex(x, c, 0);
    else if (i == 2) color = rgbToHex(0, c, x);
    else if (i == 3) color = rgbToHex(0, x, c);
    else if (i == 4) color = rgbToHex(x, 0, c);
    else color = rgbToHex(c, 0, x);

    return color;
}

function rgbToHex(red, green, blue) {
    var h = ((red << 16) | (green << 8) | (blue)).toString(16);
    // add the beginning zeros
    while (h.length < 6) h = '0' + h;
    return '#' + h;
}
