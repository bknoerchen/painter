#pragma once

#include "commandhistorycontroller/history.h"

#include <QImage>
#include <QJSValue>

class QQuickItem;

class CppController : public QObject
{
	Q_OBJECT

public:
	CppController();

	Q_INVOKABLE QImage floodFill(int & start, int & stop, const QColor & fillColor, int x, int y, int width, int height) const;
	Q_INVOKABLE void paintWithHistory(QQuickItem * quickItem, int x1, int x2, int y1, int y2, int strokeWidth, const QColor & strokeColor);

private:
	History paintHistory_;
};
