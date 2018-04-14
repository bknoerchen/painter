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
	PaintCommandBase(QImage * canvasImage)
	    : canvasImage_(canvasImage) {
	}

protected:
	QImage * canvasImage_;
	QImage undoImage_;
	std::unique_ptr<Shape> shape_;
};

#include <QDebug>
class PolylineCommand : public PaintCommandBase
{
public:
	explicit PolylineCommand(QImage * canvasImage, std::unique_ptr<Shape> && shape)
	    : canvasImage_(canvasImage)
	    , undoImage_(canvasImage->copy(s->rect())), shape_(std::move(shape))
	{
	}

	virtual void undo() override
	{
		const QRect rect = shape_->getBoundingRect();

		QPainter painter(canvasImage_);
		painter.drawImage(rect, undoImage);

		canvas_->update(rect);
	}

	virtual void execute() override
	{
		QPainter painter(canvasImage_);
		painter.setRenderHint(QPainter::Antialiasing, true);
		shape_->draw(painter);

		canvas_->update(shape->rect());
	}
}
