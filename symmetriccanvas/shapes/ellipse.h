#pragma once

#include "shape.h"

class Ellipse : public Shape
{
public:
	explicit Ellipse(const QPointF & startPoint,
	                int penWidth,
	                const QColor & penColor);
	virtual void update(const QPointF & currentPoint) override;

protected:
	virtual void drawImpl(QPainter & painter) override;
	virtual QRectF getBoundingRectImpl() const override;

private:
	QPointF startPoint_;
	QPointF endPoint_;
};
