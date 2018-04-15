#include "symmetriccanvas.h"

#include "commandhistorycontroller/paintercommands.h"

#include <QPainter>

SymmetricCanvas::SymmetricCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , penWidth_(2)
    , canvasImage_(10, 10, QImage::Format_RGB32)
    , currentShapeFactory_(0)
{
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

QString SymmetricCanvas::currentShape() const
{
	return currentShapeName_;
}

void SymmetricCanvas::setCurrentShape(const QString & shapeName)
{
	currentShapeName_ = shapeName;
	currentShapeFactory_ = ShapeFactory::getShapeFactoryForProductName(currentShapeName_);
}

void SymmetricCanvas::undo()
{
	paintHistory_.undoWithCachedData();

	update();
}

void SymmetricCanvas::paint(QPainter * painter)
{
	painter->drawImage(QPoint(0, 0), canvasImage_);

	// draw current overlay shapes temporarily while mouse is pressed
	for (auto & shape : currentShapes_) {
		shape.second->draw(*painter);
	}
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

void SymmetricCanvas::startPaint(const QPointF & startPoint, int id)
{
	currentShapes_[id] = currentShapeFactory_(startPoint, penWidth_, color_);
}

void SymmetricCanvas::updatePaint(const QPointF & currentPoint, int id)
{
	currentShapes_[id]->update(currentPoint);
	update();
}

void SymmetricCanvas::stopPaint(int id)
{
	if (currentShapes_.find(id) != currentShapes_.end()) {
		paintHistory_.add(new ShapeCommand(&canvasImage_, std::move(currentShapes_.at(id)), paintHistory_.getNextExecutionNumber()), true);
		currentShapes_.erase(id);
		update();
	}
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
