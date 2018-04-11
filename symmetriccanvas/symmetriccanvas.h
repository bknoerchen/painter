#pragma once

#include "commandhistorycontroller/history.h"

#include <QImage>
#include <QQuickPaintedItem>

class SymmetricCanvas : public QQuickPaintedItem
{
	Q_OBJECT


	Q_PROPERTY(QColor color READ color WRITE setColor)

public:
	SymmetricCanvas(QQuickItem *parent = 0);

	QColor color() const;
	void setColor(const QColor & color);

	void paint(QPainter *painter) override;
	void geometryChanged(const QRectF & newGeometry, const QRectF & oldGeometry) override;

	Q_INVOKABLE void drawShape(const QPoint & startPoint, const QPoint & endPoint);

private:
	QColor color_;
	QImage canvasImage_;
	History paintHistory_;
};
