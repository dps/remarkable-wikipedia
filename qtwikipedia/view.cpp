#include "view.h"
//#include <fb2png.h>
#include <QQuickItem>

View::View(QQmlEngine *engine, Controller* controller, QRect geometry)
: QQuickView(engine, Q_NULLPTR),
  _controller(controller) {
    QSurfaceFormat format;
    format.setAlphaBufferSize(8);
    format.setRenderableType(QSurfaceFormat::OpenGL);
    setFormat(format);
    setClearBeforeRendering(true);
    setColor(QColor(Qt::transparent));
    setMask(QRegion(0, geometry.height() - 480, geometry.width(), 480));
    setFlags(Qt::FramelessWindowHint);
//    setAttribute(Qt::WA_TranslucentBackground);
}
void View::reloadBackground(){
    qDebug() << "Generating png from framebuffer...";
    // int res = fb2png_defaults();
    // if(res){
    //     qDebug() << "Failed:" << res;
    // }
    QQuickItem* background = rootObject()->findChild<QQuickItem*>("background");
    QMetaObject::invokeMethod(background, "reload");
}

bool View::event(QEvent* e){
    e->accept();
    QEvent::Type type = e->type();
    if(type == QEvent::TouchBegin || type == QEvent::TouchCancel
            || type == QEvent::TouchEnd || type == QEvent::TouchUpdate){
        QTouchEvent* te = static_cast<QTouchEvent*>(e);
        qDebug() << te;
        emit _controller->emitableTouchEvent(te);
    }else if(type == QEvent::TabletEnterProximity || type == QEvent::TabletLeaveProximity
             || type == QEvent::TabletMove || type == QEvent::TabletPress
             || type == QEvent::TabletRelease || type == QEvent::TabletTrackingChange){
        QTabletEvent* te = static_cast<QTabletEvent*>(e);
        qDebug() << te;
        emit _controller->emitableTabletEvent(te);
    }else if(type == QEvent::MouseButtonDblClick || type == QEvent::MouseButtonPress
             || type == QEvent::MouseButtonRelease || type == QEvent::MouseMove
             || type == QEvent::MouseTrackingChange){
        QMouseEvent* me = static_cast<QMouseEvent*>(e);
        qDebug() << me;
        emit _controller->mouseEvent(me);
    }else if(type == QEvent::KeyPress || type == QEvent::KeyRelease){
        QKeyEvent* ke = static_cast<QKeyEvent*>(e);
        qDebug() << ke;
        emit _controller->keyEvent(ke);
    }else if(type == QEvent::Quit){
        emit _controller->quit();
    }
    return QQuickView::event(e);
}