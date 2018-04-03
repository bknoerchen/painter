#include "androidfiledialog.h"

AndroidFileDialog::AndroidFileDialog()
{

}

void AndroidFileDialog::searchImage()
{
	ImagePickerAndroid *imagePicker = new ImagePickerAndroid();
	connect(imagePicker, SIGNAL(imageHomePathChanged
	                            (QString)), this, SLOT(restoreImage(QString)));

	imagePicker->searchImage();
}

void AndroidFileDialog::restoreImage(QString path)
{
	imageHomePath_ = path;

	emit imageHomePathChanged();
}

QString AndroidFileDialog::imageHomePath()
{
	return imageHomePath_;
}
