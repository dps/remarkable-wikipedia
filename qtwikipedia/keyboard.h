#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <QQuickItem>
#include <QDBusConnection>
#include <view.h>

class Keyboard : public QQuickItem
{
    Q_OBJECT
public:
    explicit Keyboard(QQuickItem *parent = Q_NULLPTR) : QQuickItem(parent) { }
    void init(View* view, QDBusConnection* bus){
        _view = view;
        _bus = bus;
    }
    Q_INVOKABLE void charPress(const QChar &character, const Qt::KeyboardModifiers &modifier);
    Q_INVOKABLE void keyPress(const Qt::Key &key, const Qt::KeyboardModifiers &modifier, const QString &text);
    Q_INVOKABLE void stringPress(const QString &text, const Qt::KeyboardModifiers &modifier);
public slots:
    void showKeyboard();
    void hideKeyboard();
    bool keyboardVisible() const;
signals:
    void keyPress(QKeyEvent* event);
private:
    View* _view;
    QDBusConnection* _bus;
};

#endif // KEYBOARD_H