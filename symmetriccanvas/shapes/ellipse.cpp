#include "ellipse.h"

Ellipse::Ellipse(const QPointF & startPoint,
                 int penWidth,
                 int symmetryCount,
                 const QColor & penColor)
    : Shape(penWidth, symmetryCount, penColor)
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
