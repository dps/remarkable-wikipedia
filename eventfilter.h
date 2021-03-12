#ifndef EVENTFILTER_H
#define EVENTFILTER_H

#include <QObject>
#include <QEvent>
#include <QGuiApplication>
#include <QQuickItem>

class EventFilter : public QObject
{
    Q_OBJECT
public:
    QQuickItem* root;
    explicit EventFilter(QObject* parent = nullptr);
signals:
    void suspend();
protected:
  bool eventFilter(QObject* obj, QEvent* ev);
};

EventFilter::EventFilter(QObject *parent) : QObject(parent), root(nullptr) {

}

#endif // EVENTFILTER_H