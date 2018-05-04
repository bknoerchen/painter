#include "shape.h"

#include <QPen>

Shape::Shape(int penWidth, int symmetryCount, const QColor & penColor)
    : penWidth_(penWidth)
    , symmetryCount_(symmetryCount)
    , penColor_(penColor)
{
}

Shape::~Shape()
{
}

void Shape::draw(QPainter & painter)
{
	painter.save();

	painter.setPen(QPen(penColor_, penWidth_, Qt::SolidLine,
	                    Qt::RoundCap, Qt::SvgMiterJoin));
	painter.setRenderHints(QPainter::Antialiasing, true);

	drawImpl(painter);
	for (int i = 1; i < symmetryCount_; i++) {
		painter.translate(painter.window().width() / 2, painter.window().height() / 2);
		painter.rotate(360 / symmetryCount_);
		painter.translate(-painter.window().width() / 2, -painter.window().height() / 2);
		drawImpl(painter);
	}

	painter.restore();
}

QRectF Shape::getBoundingRect() const
{
	// Consider pen's width and make sure the outline is included in the
	// returned rectangle.
	const int rad = penWidth_ / 2 + 2;
	return getBoundingRectImpl().adjusted(-rad, -rad, +rad, +rad);
}
