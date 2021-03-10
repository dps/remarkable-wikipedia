#ifndef VIEW_H
#define VIEW_H

#include <QQuickView>
#include <QQmlEngine>
#include <QTouchEvent>
#include "controller.h"


class View : public QQuickView {
public:
    View(QQmlEngine* engine, Controller* controller, QRect geometry);
    void reloadBackground();
public slots:
    bool event(QEvent* e);
signals:
    void aboutToQuit();
    void imageChanged();
private:
    Controller* _controller;
};

#endif // VIEW_H