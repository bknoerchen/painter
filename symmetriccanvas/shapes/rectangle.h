#pragma once

#include "shape.h"

class Rectangle : public Shape
{
public:
	explicit Rectangle(const QPointF & startPoint,
	                   int penWidth_,
	                   int symmetryCount, const ShapeMirrorType & mirrorType,
	                   const QColor & penColor_);
	virtual void update(const QPointF & currentPoint) override;

protected:
	virtual void drawImpl(QPainter & painter) override;
	virtual QRectF getBoundingRectImpl() const override;

private:
	QPointF startPoint_;
	QPointF endPoint_;
};
