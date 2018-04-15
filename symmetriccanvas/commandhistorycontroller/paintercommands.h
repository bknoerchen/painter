#pragma once

#include "command.h"
#include "../shapes/shape.h"

#include <QColor>
#include <QQmlContext>

#include <memory>
#include <vector>

class PaintCommandBase : public Command
{
public:
	PaintCommandBase(QImage * canvasImage, std::unique_ptr<Shape> && shape)
	    : canvasImage_(canvasImage)
	    //std::move(canvasImage->copy(shape->getBoundingRect().toAlignedRect())))
	    , shape_(std::move(shape))
	{
	}

	void setUndoPoint() {
		undoImage_ = *canvasImage_;
	}

protected:
	QImage * canvasImage_;
	QImage undoImage_;
	std::unique_ptr<Shape> shape_;
};

#include <QDebug>
class ShapeCommand : public PaintCommandBase
{
public:
	explicit ShapeCommand(QImage * canvasImage, std::unique_ptr<Shape> && shape)
	    : PaintCommandBase(canvasImage, std::move(shape))
	{
	}

	virtual void undo() override
	{
//		const QRect rect = shape_->getBoundingRect();

//		QPainter painter(canvasImage_);
//		painter.drawImage(rect, undoImage);

//		canvas_->update(rect);
	}

	virtual void execute() override
	{
		QPainter painter(canvasImage_);
		shape_->draw(painter);
	}

	virtual void restoreUndoPoint() override
	{
		QPainter painter(canvasImage_);
		painter.drawImage(QPoint(0, 0), undoImage_);
	}
};
