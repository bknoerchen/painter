#pragma once

#include <QRect>
#include <QPainter>

class Shape
{
public:
	Shape(int penWidth, int symmetryCount, const QColor & penColor);
	virtual ~Shape();

	void draw(QPainter & painter);
	QRectF getBoundingRect() const;
	virtual void update(const QPointF & currentPoint) = 0;

protected:
	virtual void drawImpl(QPainter & painter) = 0;
	virtual QRectF getBoundingRectImpl() const = 0;

private:
	int penWidth_;
	int symmetryCount_;
	QColor penColor_;
};
