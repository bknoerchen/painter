#pragma once

#include <QImage>
#include <QStack>

typedef std::vector<QRgb>::iterator PixelIt;
typedef std::vector<QRgb>::const_iterator ConstPixelIt;

class FloodFill
{
public:
    static QImage quickFill(int & start, int & stop, const QColor & fillColor, int x, int y, int width, int height);

    struct Line {
        Line()
            : y(0)
            , dy(0)
            , valid(false)
        {}

        Line(ConstPixelIt x1, ConstPixelIt x2, int y, int dy = 0)
            : x1(x1)
            , x2(x2)
            , y(y)
            , dy(dy)
            , valid(true)
        {}

        ConstPixelIt x1;
        ConstPixelIt x2;
        int y;
        int dy;
        bool valid;
    };

private:
    FloodFill();

    static void pushLine(const Line &node);
    static FloodFill::Line popLine();

private:
    static QStack<Line> lineList_;
    static const int minX_;
    static const int minY_;
    static int maxX_;
    static int maxY_;
    static std::vector<QRgb> workingImage;
    static ConstPixelIt skipRight(const ConstPixelIt &startIt, const ConstPixelIt &endIt, const QColor &seedColor);
    static ConstPixelIt scanLeft(const ConstPixelIt &startIt, const ConstPixelIt &endIt, const QColor &seedColor);
    static ConstPixelIt scanRight(const ConstPixelIt &startIt, const ConstPixelIt &endIt, const QColor &seedColor);
    static int counter;
};
