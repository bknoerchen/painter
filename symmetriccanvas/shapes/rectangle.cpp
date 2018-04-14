#include "rectangle.h"

Rectangle::Rectangle(const QPointF & startPoint,
                   int penWidth,
                   const QColor & penColor)
    : Shape(penWidth, penColor)
    , startPoint_(startPoint)
{
}

void Rectangle::update(const QPointF & currentPoint)
{
	endPoint_ = currentPoint;
}

void Rectangle::drawImpl(QPainter & painter)
{
	painter.drawRect(QRectF(startPoint_, endPoint_));
}

QRectF Rectangle::getBoundingRectImpl() const
{
	return QRectF(startPoint_, endPoint_);
}
