#include "cppcontroller.h"

#include "imagemanipulation/floodfill.h"
#include "commandhistorycontroller/paintercommands.h"

#include <QQuickItem>

CppController::CppController() {}

QImage CppController::floodFill(int & start, int & stop, const QColor & fillColor, int x, int y, int width, int height) const
{
	return FloodFill::quickFill(start, stop, fillColor, x, y, width, height);
}

void CppController::paintWithHistory(QQuickItem * quickItem, int x1, int x2, int y1, int y2, int strokeWidth, const QColor & strokeColor)
{
	paintHistory_.add(new PaintStrokeCommand(quickItem, x1, x2, y1, y2, strokeWidth, strokeColor), true);
}
