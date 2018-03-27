#include "cppcontroller.h"

#include "floodfill.h"

CppController::CppController()
{

}

QImage CppController::floodFill(int & start, int & stop, const QColor & fillColor, int x, int y, int width, int height) const
{
    return FloodFill::quickFill(start, stop, fillColor, x, y, width, height);
}
