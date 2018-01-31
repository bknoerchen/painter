#pragma once

#include <QObject>
#include <QtAndroidExtras>

#include <QDebug>

class ImagePickerAndroid : public QObject, public QAndroidActivityResultReceiver
{
	Q_OBJECT

public:
	ImagePickerAndroid();

	void searchImage();

	virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

signals:
	void imageHomePathChanged(QString);
};

