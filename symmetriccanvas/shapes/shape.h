#pragma once

#include <QRect>
#include <QPainter>

class Shape
{
public:
	Shape(int penWidth, const QColor & penColor);
	virtual ~Shape();

	void draw(QPainter & painter);
	QRectF getBoundingRect() const;
	virtual void update(const QPointF & currentPoint) = 0;

protected:
	virtual void drawImpl(QPainter & painter) = 0;
	virtual QRectF getBoundingRectImpl() const = 0;

private:
	int penWidth;
	QColor penColor;
};
