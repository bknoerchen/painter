#pragma once

#include "shape.h"

class Polyline : public Shape
{
public:
	explicit Polyline(const QPointF & startPoint,
	                  int penWidth,
	                  const QColor & penColor);
	virtual void update(const QPointF & currentPoint) override;

protected:
	virtual void drawImpl(QPainter & painter) override;
	virtual QRectF getBoundingRectImpl() const override;

private:
	QPolygonF polylinePoints_;
};
