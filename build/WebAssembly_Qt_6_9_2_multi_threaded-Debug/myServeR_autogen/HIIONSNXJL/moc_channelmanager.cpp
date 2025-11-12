/****************************************************************************
** Meta object code from reading C++ file 'channelmanager.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../H/channelmanager.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'channelmanager.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN14ChannelManagerE_t {};
} // unnamed namespace

template <> constexpr inline auto ChannelManager::qt_create_metaobjectdata<qt_meta_tag_ZN14ChannelManagerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "ChannelManager",
        "channelDataChanged",
        "",
        "loadedChannelDataChanged",
        "isChannelChanged",
        "channelInfoUpdated",
        "publicCoursesChanged",
        "loadChannel",
        "userId",
        "getChannelData",
        "QVariantMap",
        "getChannelCourses",
        "QVariantList",
        "getPublicProfile",
        "getAuthorIdByChannelId",
        "channelId",
        "getChannelByAuthorId",
        "authorId",
        "getCoursesByAuthorId",
        "getChannelIdByUserName",
        "userName",
        "channelData",
        "loadedChannelData",
        "isChannel"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'channelDataChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'loadedChannelDataChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'isChannelChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'channelInfoUpdated'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'publicCoursesChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'loadChannel'
        QtMocHelpers::MethodData<void(const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'getChannelData'
        QtMocHelpers::MethodData<QVariantMap(const QString &)>(9, 2, QMC::AccessPublic, 0x80000000 | 10, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'getChannelCourses'
        QtMocHelpers::MethodData<QVariantList(const QString &)>(11, 2, QMC::AccessPublic, 0x80000000 | 12, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'getPublicProfile'
        QtMocHelpers::MethodData<QVariantMap(const QString &)>(13, 2, QMC::AccessPublic, 0x80000000 | 10, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'getAuthorIdByChannelId'
        QtMocHelpers::MethodData<QString(const QString &) const>(14, 2, QMC::AccessPublic, QMetaType::QString, {{
            { QMetaType::QString, 15 },
        }}),
        // Method 'getChannelByAuthorId'
        QtMocHelpers::MethodData<QVariantMap(const QString &) const>(16, 2, QMC::AccessPublic, 0x80000000 | 10, {{
            { QMetaType::QString, 17 },
        }}),
        // Method 'getCoursesByAuthorId'
        QtMocHelpers::MethodData<QVariantList(const QString &) const>(18, 2, QMC::AccessPublic, 0x80000000 | 12, {{
            { QMetaType::QString, 17 },
        }}),
        // Method 'getChannelIdByUserName'
        QtMocHelpers::MethodData<QString(const QString &)>(19, 2, QMC::AccessPublic, QMetaType::QString, {{
            { QMetaType::QString, 20 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'channelData'
        QtMocHelpers::PropertyData<QVariantMap>(21, 0x80000000 | 10, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'loadedChannelData'
        QtMocHelpers::PropertyData<QVariantMap>(22, 0x80000000 | 10, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'isChannel'
        QtMocHelpers::PropertyData<bool>(23, QMetaType::Bool, QMC::DefaultPropertyFlags, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<ChannelManager, qt_meta_tag_ZN14ChannelManagerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject ChannelManager::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14ChannelManagerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14ChannelManagerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14ChannelManagerE_t>.metaTypes,
    nullptr
} };

void ChannelManager::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<ChannelManager *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->channelDataChanged(); break;
        case 1: _t->loadedChannelDataChanged(); break;
        case 2: _t->isChannelChanged(); break;
        case 3: _t->channelInfoUpdated(); break;
        case 4: _t->publicCoursesChanged(); break;
        case 5: _t->loadChannel((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 6: { QVariantMap _r = _t->getChannelData((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 7: { QVariantList _r = _t->getChannelCourses((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 8: { QVariantMap _r = _t->getPublicProfile((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 9: { QString _r = _t->getAuthorIdByChannelId((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 10: { QVariantMap _r = _t->getChannelByAuthorId((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 11: { QVariantList _r = _t->getCoursesByAuthorId((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 12: { QString _r = _t->getChannelIdByUserName((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (ChannelManager::*)()>(_a, &ChannelManager::channelDataChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (ChannelManager::*)()>(_a, &ChannelManager::loadedChannelDataChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (ChannelManager::*)()>(_a, &ChannelManager::isChannelChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (ChannelManager::*)()>(_a, &ChannelManager::channelInfoUpdated, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (ChannelManager::*)()>(_a, &ChannelManager::publicCoursesChanged, 4))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantMap*>(_v) = _t->channelData(); break;
        case 1: *reinterpret_cast<QVariantMap*>(_v) = _t->loadedChannelData(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->isChannel(); break;
        default: break;
        }
    }
}

const QMetaObject *ChannelManager::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ChannelManager::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14ChannelManagerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ChannelManager::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 13)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 13)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 13;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void ChannelManager::channelDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void ChannelManager::loadedChannelDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void ChannelManager::isChannelChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void ChannelManager::channelInfoUpdated()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void ChannelManager::publicCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}
QT_WARNING_POP
