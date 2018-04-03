TEMPLATE = lib
CONFIG += plugin
QT += qml quick

TARGET = paintercanvasplugin

SOURCES += \
    paintercanvasplugin.cpp \
    paintercanvas.cpp

CONFIG(debug, debug|release) {
    DESTDIR =     ../bin/debug/PainterCanvas
    OBJECTS_DIR = ../bin/debug/PainterCanvas/.obj
    MOC_DIR =     ../bin/debug/PainterCanvas/.moc
    RCC_DIR =     ../bin/debug/PainterCanvas/.rcc
    UI_DIR =      ../bin/debug/PainterCanvas/.ui
} else {
    DESTDIR =     ../bin/release/PainterCanvas
    OBJECTS_DIR = ../bin/release/PainterCanvas/.obj
    MOC_DIR =     ../bin/release/PainterCanvas/.moc
    RCC_DIR =     ../bin/release/PainterCanvas/.rcc
    UI_DIR =      ../bin/release/PainterCanvas/.ui
}

HEADERS += \
    paintercanvasplugin.h \
    paintercanvas.h

target.path = $$DESTDIR
qmldir.files = $$PWD/qmldir
qmldir.path = $$DESTDIR
INSTALLS += target qmldir

CONFIG += install_ok

OTHER_FILES += qmldir

# Copy the qmldir file to the same folder as the plugin binary
cpqmldir.files = qmldir
cpqmldir.path = $$DESTDIR
COPIES += cpqmldir
