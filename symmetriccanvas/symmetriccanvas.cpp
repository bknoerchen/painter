#include "symmetriccanvas.h"

#include "shapes/shapefactory.h"

#include <QPainter>

SymmetricCanvas::SymmetricCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , penWidth_(2)
    , canvasImage_(10, 10, QImage::Format_RGB32)
    , shapeFactory_(ShapeFactoryProducts::createPolyline)
//    , currentShape_(shapeFactory_())
{
	canvasImage_.fill(Qt::red);

	//qDebug() << property("width").toInt() << property("height").toInt();


	QPen pen(color_, 2);
	QPainter painter(&canvasImage_);
	painter.setPen(pen);
	painter.setRenderHints(QPainter::Antialiasing, true);
	painter.drawLine(QPoint(1,1), QPoint(30,30));

	    painter.drawPolyline(QPolygonF() << QPoint(1,1) << QPoint(30,30));
}

QColor SymmetricCanvas::color() const
{
	return color_;
}

void SymmetricCanvas::setColor(const QColor & color)
{
	color_ = color;
}

int SymmetricCanvas::penWidth() const
{
	return penWidth_;
}

void SymmetricCanvas::setPenWidth(int penWidth)
{
	penWidth_ = penWidth;
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

void SymmetricCanvas::drawShape(const QPointF & startPoint, const QPointF & endPoint)
{
	QPainter painter(&canvasImage_);
	auto shape = shapeFactory_(startPoint, penWidth_, color_);
	shape->update(endPoint);
	shape->draw(painter);

	// update rect ????
	update();
}


//void Document::mousePressEvent(QMouseEvent *event)
//{
//	if (event->button() == Qt::LeftButton && factory) {
//		currentShape = factory(event->pos(), penWidth, penColor);
//	}
//}

//void Document::mouseMoveEvent(QMouseEvent *event)
//{
//	if ((event->buttons() & Qt::LeftButton) && currentShape) {

//		const QRect prevRect = currentShape->rect();
//		currentShape->update(event->pos());

//		update(currentShape->rect().united(prevRect));
//	}
//}

//void Document::mouseReleaseEvent(QMouseEvent *event)
//{
//	if (event->button() == Qt::LeftButton && currentShape) {
//		// Done with drawind the image.  Now pass the buck to the undo stack.
//		undoStack->push(new ShapeCommand(this, &image,
//		                                 std::move(currentShape)));
//	}
//}
