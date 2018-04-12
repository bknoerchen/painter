#pragma once

#include "commandhistorycontroller/history.h"
#include "shapes/shape.h"

#include <QImage>
#include <QQuickPaintedItem>

#include <functional>
#include <memory>

class SymmetricCanvas : public QQuickPaintedItem
{
	Q_OBJECT

	Q_PROPERTY(QColor color READ color WRITE setColor)
	Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth)

	typedef std::function<std::unique_ptr<Shape>(
	        const QPointF &, int, const QColor &)> ShapeFactory;

public:
	SymmetricCanvas(QQuickItem *parent = 0);

	QColor color() const;
	void setColor(const QColor & color);

	int penWidth() const;
	void setPenWidth(int penWidth);

	Q_INVOKABLE void drawShape(const QPointF & startPoint, const QPointF & endPoint);

protected:
	void paint(QPainter *painter) override;
	void geometryChanged(const QRectF & newGeometry, const QRectF & oldGeometry) override;

private:
	QColor color_;
	int penWidth_;
	QImage canvasImage_;
	History paintHistory_;
	ShapeFactory shapeFactory_;
	//std::unique_ptr<Shape> currentShape_;
};
