#pragma once

#include "commandhistorycontroller/history.h"
#include "shapes/shapefactory.h"

#include <QImage>
#include <QQuickPaintedItem>

#include <memory>

class SymmetricCanvas : public QQuickPaintedItem
{
	Q_OBJECT

	Q_PROPERTY(QColor color READ color WRITE setColor)
	Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth)
	Q_PROPERTY(QString currentShape READ currentShape WRITE setCurrentShape)

public:
	SymmetricCanvas(QQuickItem *parent = 0);

	// properties
	QColor color() const;
	void setColor(const QColor & color);

	int penWidth() const;
	void setPenWidth(int penWidth);

	QString currentShape() const;
	void setCurrentShape(const QString & shapeName);

	// invokable functions
	Q_INVOKABLE void redo();
	Q_INVOKABLE void undo();

	Q_INVOKABLE void startPaint(const QPointF & startPoint, int id);
	Q_INVOKABLE void updatePaint(const QPointF & currentPoint, int id);
	Q_INVOKABLE void stopPaint(int id);

protected:
	void paint(QPainter *painter) override;
	void geometryChanged(const QRectF & newGeometry, const QRectF & oldGeometry) override;

private:
	QColor color_;
	int penWidth_;
	QImage canvasImage_;
	History paintHistory_;

	QString currentShapeName_;
	ShapeFactoryFunction currentShapeFactory_;
	std::map<int /*touchId*/, std::unique_ptr<Shape>> currentShapes_;
};
