#include "paintercanvas.h"

#include <QPainter>

PainterCanvas::PainterCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
}

QColor PainterCanvas::color() const
{
	return color_;
}

void PainterCanvas::setColor(const QColor & color)
{
	color_ = color;
}

void PainterCanvas::paint(QPainter * painter)
{
	QPen pen(color_, 2);
	painter->setPen(pen);
	painter->setRenderHints(QPainter::Antialiasing, true);
	painter->drawLine(startPoint_, endPoint_);
}

void PainterCanvas::setStartPoint(const QPoint & startPoint)
{
	startPoint_ = startPoint;
}

void PainterCanvas::setEndPoint(const QPoint & endPoint)
{
	endPoint_ = endPoint;
	update();
}

QPoint PainterCanvas::getStartPoint() const
{
	return startPoint_;
}

QPoint PainterCanvas::getEndPoint() const
{
	return endPoint_;
}
