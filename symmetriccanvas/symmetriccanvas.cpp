#include "symmetriccanvas.h"

#include <QPainter>

#include <QtDebug>

SymmetricCanvas::SymmetricCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , canvasImage_(10, 10, QImage::Format_RGB32)
{
	canvasImage_.fill(Qt::red);

	qDebug() << property("width").toInt() << property("height").toInt();


	QPen pen(color_, 2);
	QPainter painter(&canvasImage_);
	painter.setPen(pen);
	painter.setRenderHints(QPainter::Antialiasing, true);
	painter.drawLine(QPoint(1,1), QPoint(30,30));
}

QColor SymmetricCanvas::color() const
{
	return color_;
}

void SymmetricCanvas::setColor(const QColor & color)
{
	color_ = color;
}

void SymmetricCanvas::paint(QPainter * painter)
{
	painter->drawImage(QPoint(0, 0), canvasImage_);
}

void SymmetricCanvas::geometryChanged(const QRectF & newGeometry, const QRectF & oldGeometry)
{
	Q_UNUSED(oldGeometry);

	const QSize canvasSize = newGeometry.toAlignedRect().size();

	if (!canvasSize.isEmpty()) {
		canvasImage_ = canvasImage_.scaled(canvasSize);
		canvasImage_.fill(Qt::red);
		update();
	}
}

void SymmetricCanvas::drawShape(const QPoint & startPoint, const QPoint & endPoint)
{

}
