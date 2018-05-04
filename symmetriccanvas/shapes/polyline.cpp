#include "polyline.h"

Polyline::Polyline(const QPointF & startPoint,
                   int penWidth,
                   int symmetryCount, const ShapeMirrorType & mirrorType,
                   const QColor & penColor)
    : Shape{penWidth, symmetryCount, mirrorType, penColor}
{
	polylinePoints_ << startPoint;
}

void Polyline::update(const QPointF & currentPoint)
{
	polylinePoints_ << currentPoint;
}

void Polyline::drawImpl(QPainter & painter)
{
	painter.drawPolyline(polylinePoints_);
}

QRectF Polyline::getBoundingRectImpl() const
{
	return polylinePoints_.boundingRect();
}
