#pragma once

#include "imagepickerandroid.h"

class AndroidFileDialog : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString imageHome READ imageHomePath NOTIFY imageHomePathChanged)

public slots:
	void searchImage();
	void restoreImage(QString path);

public:
	AndroidFileDialog();

	QString imageHomePath();

private:
	QString imageHomePath_ = "";

signals:
	void imageHomePathChanged();
};
