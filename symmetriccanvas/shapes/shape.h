#pragma once

#include <QRect>
#include <QPainter>

class MirrorType {
	Q_GADGET
public:
	enum Type {
		MirrorOff = 0,
		MirrorOnX,
		MirrorOnY
	};
	Q_ENUM(Type)
};
typedef MirrorType::Type ShapeMirrorType;

class Shape
{
public:
	Shape(int penWidth, int symmetryCount, const ShapeMirrorType & mirrorType, const QColor & penColor);
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
	ShapeMirrorType mirrorType_;
	QColor penColor_;
};
