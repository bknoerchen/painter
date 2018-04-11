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
	drawImpl(painter);
	painter.setPen(prevPen);
}

QRect Shape::getBoundingRect() const
{
	// Consider pen's width and make sure the outline is included in the
	// returned rectangle.
	const int rad = penWidth / 2 + 2;
	return getBoundingRectImpl().adjusted(-rad, -rad, +rad, +rad);
}

void Shape::update(const QPoint & toPoint)
{
	updateImpl(toPoint);
}


Polyline::Polyline(const QPoint &topLeft,
                   int penWidth,
                   const QColor &penColor) :
    Shape(penWidth, penColor)
{
	update(topLeft);
}

void Polyline::drawImpl(QPainter &painter)
{
	painter.drawPolyline(poly);
}

QRect Polyline::getBoundingRectImpl() const
{
	return poly.boundingRect();
}

void Polyline::updateImpl(const QPoint &toPoint)
{
	poly << toPoint;
}
