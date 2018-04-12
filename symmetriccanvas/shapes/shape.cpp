#include "shape.h"

#include <QPen>

Shape::Shape(int penWidth, const QColor & penColor) :
    penWidth(penWidth), penColor(penColor)
{
}

Shape::~Shape()
{
}

void Shape::draw(QPainter & painter)
{
	const QPen prevPen = painter.pen();

	painter.setPen(QPen(penColor, penWidth, Qt::SolidLine,
	                    Qt::RoundCap, Qt::RoundJoin));
	painter.setRenderHints(QPainter::Antialiasing, true);

	drawImpl(painter);

	painter.setRenderHints(QPainter::Antialiasing, false);
	painter.setPen(prevPen);
}

QRectF Shape::getBoundingRect() const
{
	// Consider pen's width and make sure the outline is included in the
	// returned rectangle.
	const int rad = penWidth / 2 + 2;
	return getBoundingRectImpl().adjusted(-rad, -rad, +rad, +rad);
}

void Shape::update(const QPointF & toPoint)
{
	updateImpl(toPoint);
}
