#pragma once

#include <QRect>
#include <QPainter>

class Shape
{
public:
	Shape(int penWidth, const QColor & penColor);

	virtual ~Shape();

	void draw(QPainter & painter);
	QRect getBoundingRect() const;
	void update(const QPoint & toPoint);

protected:
	virtual void drawImpl(QPainter &painter) = 0;
	virtual QRect getBoundingRectImpl() const = 0;
	virtual void updateImpl(const QPoint &toPoint) = 0;

private:
	int penWidth;
	QColor penColor;
};


class Polyline : public Shape
{
public:
	explicit Polyline(const QPoint &topLeft,
	                  int penWidth,
	                  const QColor& penColor);

protected:
	virtual void drawImpl(QPainter &painter) override;
	virtual QRect getBoundingRectImpl() const override;
	virtual void updateImpl(const QPoint &toPoint) override;

private:
	QPolygon poly;
};


//std::unique_ptr<Shape> createScribble(const QPoint &topLeft,
//                                      int penWidth,
//                                      const QColor& penColor)
//{
//	return std::unique_ptr<Shape>(new Polyline(topLeft, penWidth, penColor));
//}
