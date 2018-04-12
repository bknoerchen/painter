#include "polyline.h"

Polyline::Polyline(const QPointF & topLeft,
                   int penWidth,
                   const QColor & penColor) :
    Shape(penWidth, penColor)
{
	update(topLeft);
}

void Polyline::drawImpl(QPainter & painter)
{
	painter.drawPolyline(poly);
}

QRectF Polyline::getBoundingRectImpl() const
{
	return poly.boundingRect();
}

void Polyline::updateImpl(const QPointF & toPoint)
{
	poly << toPoint;
}
