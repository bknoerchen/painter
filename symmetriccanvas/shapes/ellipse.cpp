#include "ellipse.h"

Ellipse::Ellipse(const QPointF & startPoint,
               int penWidth,
               const QColor & penColor)
    : Shape(penWidth, penColor)
    , startPoint_(startPoint)
{
}

void Ellipse::update(const QPointF & currentPoint)
{
	endPoint_ = currentPoint;
}

void Ellipse::drawImpl(QPainter & painter)
{
	painter.drawEllipse(QRectF(startPoint_, endPoint_));
}

QRectF Ellipse::getBoundingRectImpl() const
{
	return QRectF(startPoint_, endPoint_);
}
