#pragma once

#include <QQuickPaintedItem>

class PainterCanvas : public QQuickPaintedItem
{
	Q_OBJECT

	Q_PROPERTY(QPoint startPoint READ getStartPoint WRITE setStartPoint)
	Q_PROPERTY(QPoint endPoint READ getEndPoint WRITE setEndPoint)
	Q_PROPERTY(QColor color READ color WRITE setColor)

public:
	PainterCanvas(QQuickItem *parent = 0);

	QColor color() const;
	void setColor(const QColor & color);

	void paint(QPainter *painter);

	void setStartPoint(const QPoint & getStartPoint);
	void setEndPoint(const QPoint & getEndPoint);

	QPoint getStartPoint() const;
	QPoint getEndPoint() const;

private:
	QPoint startPoint_;
	QPoint endPoint_;
	QColor color_;
};
