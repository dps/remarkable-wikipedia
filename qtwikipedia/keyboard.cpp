#include "keyboard.h"


void Keyboard::charPress(const QChar &character, const Qt::KeyboardModifiers &modifier){
    if(character != '\x0'){
        int key = character.unicode();
        QKeyEvent* event = new QKeyEvent(QEvent::KeyPress, key, modifier, QString(character));
        QObject* target = _view->focusObject();
        if(!target){
            qDebug() << "No target";
            return;
        }
        qDebug() << target;
        QCoreApplication::postEvent(target, event);
        qDebug() << "Char pressed: " << QKeySequence(key + modifier).toString();
    }else{
        qDebug() << "Invalid char";
        keyPress(Qt::Key_unknown, modifier, QString());
    }
}
void Keyboard::keyPress(const Qt::Key &key, const Qt::KeyboardModifiers &modifier, const QString &text){
    QKeyEvent* event = new QKeyEvent(QEvent::KeyPress, key, modifier, text);
    QObject* target = _view->focusObject();
    if(!target){
        qDebug() << "No target";
        emit keyPress(event);
        return;
    }
    qDebug() << target;
    QCoreApplication::postEvent(target, event);
    QKeySequence sequence;
    switch(key){
        case Qt::Key_Shift:
        case Qt::Key_Alt:
        case Qt::Key_AltGr:
        case Qt::Key_Control:
        case Qt::Key_Meta:
            sequence = QKeySequence(modifier);
            break;
        default:
            sequence = QKeySequence(key + modifier);
            break;
    }
    qDebug() << "Key pressed: " << sequence.toString() << " text: " << text;
}
void Keyboard::stringPress(const QString &text, const Qt::KeyboardModifiers &modifier){
    QKeyEvent* event = new QKeyEvent(QEvent::KeyPress, Qt::Key_unknown, modifier, text);
    QObject* target = _view->focusObject();
    if(!target){
        qDebug() << "No target";
        emit keyPress(event);
        return;
    }
    qDebug() << target;
    QCoreApplication::postEvent(target, event);
    QVariant readOnly = target->property("readOnly");
    QVariant length = target->property("length");
    if(target->property("text").isValid() && length.isValid() && readOnly.isValid() && !readOnly.toBool()){
        QMetaObject::invokeMethod(target, "insert", Q_ARG(int, length.toInt()), Q_ARG(QString, text));
    }
    qDebug() << "String pressed: " << QKeySequence(text + modifier).toString();
}
void Keyboard::showKeyboard(){
    _view->reloadBackground();
    _view->show();
    QQuickItem::setVisible(true);
}
void Keyboard::hideKeyboard(){
    QQuickItem::setVisible(false);
}
bool Keyboard::keyboardVisible() const{
    return _view->isVisible() && QQuickItem::isVisible();
}