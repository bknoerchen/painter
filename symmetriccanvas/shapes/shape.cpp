#include "shape.h"

#include <QPen>

Shape::Shape(int penWidth, const QColor & penColor)
    : penWidth(penWidth)
    , penColor(penColor)
{
}

Shape::~Shape()
{
}

void Shape::draw(QPainter & painter)
{
	painter.save();

	painter.setPen(QPen(penColor, penWidth, Qt::SolidLine,
	                    Qt::RoundCap, Qt::SvgMiterJoin));
	painter.setRenderHints(QPainter::Antialiasing, true);

	drawImpl(painter);

	painter.restore();
}

QRectF Shape::getBoundingRect() const
{
	// Consider pen's width and make sure the outline is included in the
	// returned rectangle.
	const int rad = penWidth / 2 + 2;
	return getBoundingRectImpl().adjusted(-rad, -rad, +rad, +rad);
}
