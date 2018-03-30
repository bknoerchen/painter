#pragma once

#include "command.h"

#include <QColor>
#include <QJSValue>
#include <QQmlContext>
#include <QQuickItem>
#include <QVariant>

class PaintCommandBase : public Command
{
public:
	PaintCommandBase(const QJSValue & context2D)
	    : context2D(context2D) {
	}

protected:
	QJSValue context2D;
};

#include <QDebug>
class PaintStrokeCommand : public PaintCommandBase
{
public:
	PaintStrokeCommand(QQuickItem * quickItem, int x1, int x2, int y1, int y2, int strokeWidth, const QColor & strokeColor)
	    : PaintCommandBase(context2D)
	    , quickItem_(quickItem)
	    , x1_(x1)
	    , x2_(x2)
	    , y1_(y1)
	    , y2_(y2)
	    , strokeWidth_(strokeWidth)
	    , strokeColor_(strokeColor) {
	}

	void execute() override {
		QVariant context2Dvar;

		void * context2Dv = quickItem_->property("context").value<void*>();

		QJSValue * context2D = reinterpret_cast<QJSValue*>(context2Dv);



//		QMetaObject::invokeMethod(quickItem_, "getContext",
//		                          Qt::DirectConnection,
//		                          Q_RETURN_ARG(QVariant, context2Dvar),
//		                          Q_ARG(QVariant, "2D"));

//		QJSValue context2D = context2Dvar.value<QJSValue>();

		context2D->property("strokeStyle").call(QJSValueList() << QJSValue(strokeColor_.name()));
		context2D->property("beginPath").call();
		context2D->property("moveTo").call(QJSValueList() << QJSValue(x1_) << QJSValue(y1_));
		context2D->property("lineTo").call(QJSValueList() << QJSValue(x2_) << QJSValue(y2_));
		context2D->property("stroke").call();

	}
	void undo() override {

	}

private:
	QQuickItem * quickItem_;
	int x1_;
	int x2_;
	int y1_;
	int y2_;
	int strokeWidth_;
	QColor strokeColor_;
};

