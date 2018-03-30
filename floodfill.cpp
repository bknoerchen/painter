#include "floodfill.h"

#include <QJSEngine>
#include <QDebug>

Q_DECLARE_METATYPE(QRgb*)

#define getFirstPixelOfLine(y) ::workingImage.cbegin() + y * maxX_
#define getLastPixelOfLine(y) ::workingImage.cbegin() + (y + 1) * maxX_ - 1
#define getPixelXOfLine(x,y) ::workingImage.cbegin() + y * maxX_ + x
#define moveToChildRow(it, dy) it + dy * maxX_

QStack<FloodFill::Line> lineList_;
std::vector<QRgb> workingImage;
const int FloodFill::minX_ = 0;
const int FloodFill::minY_ = 0;
int FloodFill::maxX_ = 0;
int FloodFill::maxY_ = 0;

void FloodFill::pushLine(const Line & node)
{
	::lineList_.push(node);
}

FloodFill::Line FloodFill::popLine()
{
	if (::lineList_.isEmpty()) {
		return Line();
	}
	return ::lineList_.pop();
}

// searches for the first value not equal to given color; returns the last pixel of seed color
ConstPixelIt FloodFill::scanRight(const ConstPixelIt & startIt, const ConstPixelIt & endIt, const QColor & seedColor)
{
	//deb(startIt, endIt, "scanLeft");
	for (ConstPixelIt it = startIt; it != endIt; ++it) {
		if (seedColor != *it) {
			return it - 1;
		}
	}
	return seedColor != *endIt ? endIt - 1 : endIt;
}

// searches for the first value not equal to given color; returns the last pixel of seed color
ConstPixelIt FloodFill::scanLeft(const ConstPixelIt & startIt, const ConstPixelIt & endIt, const QColor & seedColor)
{
	//deb(startIt, endIt, "scanLeft");

	for (ConstPixelIt it = startIt; it != endIt; --it) {
		if (seedColor != *it) {
			return it + 1;
		}
	}
	return seedColor != *endIt ? endIt + 1 : endIt;
}

// searches for first value that is equal to given color value.
ConstPixelIt FloodFill::skipRight(const ConstPixelIt & startIt, const ConstPixelIt & endIt, const QColor & seedColor)
{
	for(ConstPixelIt it = startIt; it != endIt; ++it) {
		//qDebug() << getValue(it) % maxX_;
		if (seedColor == *it) {
			return it;
		}
	}
	return seedColor == *endIt ? endIt : endIt + 1;
}

QImage FloodFill::quickFill(int & start, int & stop, const QColor & fillColor, int x, int y, int width, int height)
{
	::workingImage.resize(width * height);

	uchar * dest = (uchar*)malloc(width * height * 8);
	memcpy(&start, dest, width * height * 8);

	//std::copy(&start, &stop, ::workingImage);

	//memmove(::workingImage.data(), canvas.bits(), canvas.height() * canvas.width() * sizeof(QRgb));

	maxX_ = width;
	maxY_ = height;

	if (x < minX_ || x >= maxX_ || y < minY_ || y >= maxY_) {
		return QImage();
	}

	const QColor seedColor = *getPixelXOfLine(x,y);

	const ConstPixelIt childLeftStart  = scanLeft(getPixelXOfLine(x, y), getFirstPixelOfLine(y), seedColor);
	const ConstPixelIt childRightStart = scanRight(getPixelXOfLine(x, y), getLastPixelOfLine(y), seedColor);


	// start line for going up, this is one above the initial y, we make a child line,
	// this means we move its iterators from the current line to the to y corresponding line (+maxX_)
	pushLine(Line(childLeftStart, childRightStart, y, 1));

	// start line for going down, first one is the line corresponding to initial y, so don't make a child line,
	// childLeftStart and childRightStart are allready located in the to y corresponding row
	pushLine(Line(childLeftStart + maxX_, childRightStart + maxX_, ++y, -1));

	// now start flooding
	while (!::lineList_.isEmpty()) {
		const Line currentNode = popLine();

		if (!currentNode.valid) {
			continue;
		}

		const int dy = currentNode.dy;
		const int y = currentNode.y + dy;

		if (y < 0 || y > maxY_) {
			continue;
		}

		const ConstPixelIt parentLeft = moveToChildRow(currentNode.x1, dy);
		const ConstPixelIt parentRight = moveToChildRow(currentNode.x2, dy);

		ConstPixelIt childLeft = scanLeft(parentLeft, getFirstPixelOfLine(y), seedColor);
		ConstPixelIt childRight;

		if (std::distance(childLeft, parentLeft) >= 0) {
			// find ChildRight end (this should not fail here)
			childRight = scanRight(parentLeft + 1, getLastPixelOfLine(y), seedColor);

			// fill line, first remove constness for modifying, paint from right to left
			for(PixelIt it = ::workingImage.erase(childLeft, childLeft); it != childRight + 1; ++it) {
				*it = fillColor.rgb();
			}

			if (std::distance(parentLeft - 1,  childLeft) < 0 || std::distance(childRight, parentRight + 1) < 0) {
				if (childLeft == parentLeft) {
					pushLine(Line(parentRight + 2, childRight, y, -dy));
				} else if (childRight == parentRight) {
					pushLine(Line(childLeft, parentLeft - 2, y, -dy));
				} else {
					pushLine(Line(childLeft, parentLeft, y, -dy));
				}
			}
			pushLine(Line(childLeft, childRight, y, dy));

			++childRight;
		} else {
			childRight = parentLeft;
		}

		// fill betweens
		while (std::distance(childRight, parentRight) > 0) {
			// skip to new ChildLeft end ( ChildRight>ParentRight on failure )
			childRight = skipRight(childRight + 1, parentRight + 1, seedColor);

			// if new ChildLeft end found
			if (std::distance(childRight, parentRight) >= 0) {
				childLeft = childRight;

				// find ChildRight end ( this should not fail here )
				childRight = scanRight(childLeft + 1, getLastPixelOfLine(y), seedColor);

				// fill line, first remove constness for modifying
				for(PixelIt it = ::workingImage.erase(childLeft, childLeft); it != childRight + 1; ++it) {
					*it = fillColor.rgb();
				}

				// push unvisited lines
				if (std::distance(childRight, parentRight + 1) >= 0) {
					pushLine(Line(childLeft, childRight, y, dy));
				} else {
					pushLine(Line(childLeft, childRight ,y , -dy));
					pushLine(Line(childLeft, childRight ,y , dy));
				}
				// addvance ChildRight end onto border
				++childRight;
			}
		}
	}
	return QImage();//(uchar*)::workingImage.data(), canvas.height(), canvas.width(), QImage::Format_RGB32);
}
