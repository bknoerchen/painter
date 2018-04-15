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
	PaintCommandBase(QImage * canvasImage, std::unique_ptr<Shape> && shape, int commandStackSize)
	    : canvasImage_(canvasImage)
	    , undoImage_((commandStackSize % MAX_REDRAW_STEPS == 0) ? *canvasImage : QImage()) // only save the canvas every MAX_REDRAW_STEPS steps
	    //std::move(canvasImage->copy(shape->getBoundingRect().toAlignedRect())))
	    , shape_(std::move(shape))
	{
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
	explicit ShapeCommand(QImage * canvasImage, std::unique_ptr<Shape> && shape, int commandStackSize)
	    : PaintCommandBase(canvasImage, std::move(shape), commandStackSize)
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

	virtual void revert() override
	{
		QPainter painter(canvasImage_);
		painter.drawImage(QPoint(0, 0), undoImage_);
	}
};
