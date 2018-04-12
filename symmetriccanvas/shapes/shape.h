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
	void update(const QPointF & toPoint);

protected:
	virtual void drawImpl(QPainter &painter) = 0;
	virtual QRectF getBoundingRectImpl() const = 0;
	virtual void updateImpl(const QPointF &toPoint) = 0;

private:
	int penWidth;
	QColor penColor;
};
