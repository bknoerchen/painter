#pragma once

#include "shape.h"

class Polyline : public Shape
{
public:
	explicit Polyline(const QPointF & topLeft,
	                  int penWidth,
	                  const QColor & penColor);

protected:
	virtual void drawImpl(QPainter & painter) override;
	virtual QRectF getBoundingRectImpl() const override;
	virtual void updateImpl(const QPointF & toPoint) override;

private:
	QPolygonF poly;
};
