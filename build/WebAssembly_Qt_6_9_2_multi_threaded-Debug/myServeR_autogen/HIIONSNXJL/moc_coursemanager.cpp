/****************************************************************************
** Meta object code from reading C++ file 'coursemanager.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../H/coursemanager.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'coursemanager.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN13CourseManagerE_t {};
} // unnamed namespace

template <> constexpr inline auto CourseManager::qt_create_metaobjectdata<qt_meta_tag_ZN13CourseManagerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "CourseManager",
        "allCoursesChanged",
        "",
        "myCoursesChanged",
        "createdCoursesChanged",
        "isLoadingChanged",
        "courseDetailsLoaded",
        "courseId",
        "courseCreated",
        "courseUpdated",
        "courseDeleted",
        "enrollmentStatusChanged",
        "enrolled",
        "apiError",
        "errorMessage",
        "onApiReplyFinished",
        "QNetworkReply*",
        "reply",
        "allCourses",
        "QVariantList",
        "myCourses",
        "createdCourses",
        "getCourse",
        "QVariantMap",
        "getCourseDetails",
        "loadCourses",
        "loadCourseDetails",
        "createCourse",
        "courseData",
        "updateCourse",
        "deleteCourse",
        "enrollInCourse",
        "isLoading"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'allCoursesChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'myCoursesChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'createdCoursesChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'isLoadingChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'courseDetailsLoaded'
        QtMocHelpers::SignalData<void(const QString &)>(6, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Signal 'courseCreated'
        QtMocHelpers::SignalData<void(const QString &)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Signal 'courseUpdated'
        QtMocHelpers::SignalData<void(const QString &)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Signal 'courseDeleted'
        QtMocHelpers::SignalData<void(const QString &)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Signal 'enrollmentStatusChanged'
        QtMocHelpers::SignalData<void(const QString &, bool)>(11, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 }, { QMetaType::Bool, 12 },
        }}),
        // Signal 'apiError'
        QtMocHelpers::SignalData<void(const QString &)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Slot 'onApiReplyFinished'
        QtMocHelpers::SlotData<void(QNetworkReply *)>(15, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 16, 17 },
        }}),
        // Method 'allCourses'
        QtMocHelpers::MethodData<QVariantList() const>(18, 2, QMC::AccessPublic, 0x80000000 | 19),
        // Method 'myCourses'
        QtMocHelpers::MethodData<QVariantList() const>(20, 2, QMC::AccessPublic, 0x80000000 | 19),
        // Method 'createdCourses'
        QtMocHelpers::MethodData<QVariantList() const>(21, 2, QMC::AccessPublic, 0x80000000 | 19),
        // Method 'getCourse'
        QtMocHelpers::MethodData<QVariantMap(const QString &) const>(22, 2, QMC::AccessPublic, 0x80000000 | 23, {{
            { QMetaType::QString, 7 },
        }}),
        // Method 'getCourseDetails'
        QtMocHelpers::MethodData<QVariantMap(const QString &) const>(24, 2, QMC::AccessPublic, 0x80000000 | 23, {{
            { QMetaType::QString, 7 },
        }}),
        // Method 'loadCourses'
        QtMocHelpers::MethodData<void()>(25, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'loadCourseDetails'
        QtMocHelpers::MethodData<void(const QString &)>(26, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Method 'createCourse'
        QtMocHelpers::MethodData<void(const QVariantMap &)>(27, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 23, 28 },
        }}),
        // Method 'updateCourse'
        QtMocHelpers::MethodData<void(const QString &, const QVariantMap &)>(29, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 }, { 0x80000000 | 23, 28 },
        }}),
        // Method 'deleteCourse'
        QtMocHelpers::MethodData<void(const QString &)>(30, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Method 'enrollInCourse'
        QtMocHelpers::MethodData<void(const QString &)>(31, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'allCourses'
        QtMocHelpers::PropertyData<QVariantList>(18, 0x80000000 | 19, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'myCourses'
        QtMocHelpers::PropertyData<QVariantList>(20, 0x80000000 | 19, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'createdCourses'
        QtMocHelpers::PropertyData<QVariantList>(21, 0x80000000 | 19, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 2),
        // property 'isLoading'
        QtMocHelpers::PropertyData<bool>(32, QMetaType::Bool, QMC::DefaultPropertyFlags, 3),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<CourseManager, qt_meta_tag_ZN13CourseManagerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject CourseManager::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13CourseManagerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13CourseManagerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN13CourseManagerE_t>.metaTypes,
    nullptr
} };

void CourseManager::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<CourseManager *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->allCoursesChanged(); break;
        case 1: _t->myCoursesChanged(); break;
        case 2: _t->createdCoursesChanged(); break;
        case 3: _t->isLoadingChanged(); break;
        case 4: _t->courseDetailsLoaded((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 5: _t->courseCreated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 6: _t->courseUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 7: _t->courseDeleted((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 8: _t->enrollmentStatusChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        case 9: _t->apiError((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 10: _t->onApiReplyFinished((*reinterpret_cast< std::add_pointer_t<QNetworkReply*>>(_a[1]))); break;
        case 11: { QVariantList _r = _t->allCourses();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 12: { QVariantList _r = _t->myCourses();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 13: { QVariantList _r = _t->createdCourses();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 14: { QVariantMap _r = _t->getCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 15: { QVariantMap _r = _t->getCourseDetails((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 16: _t->loadCourses(); break;
        case 17: _t->loadCourseDetails((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 18: _t->createCourse((*reinterpret_cast< std::add_pointer_t<QVariantMap>>(_a[1]))); break;
        case 19: _t->updateCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QVariantMap>>(_a[2]))); break;
        case 20: _t->deleteCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 21: _t->enrollInCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 10:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply* >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)()>(_a, &CourseManager::allCoursesChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)()>(_a, &CourseManager::myCoursesChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)()>(_a, &CourseManager::createdCoursesChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)()>(_a, &CourseManager::isLoadingChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)(const QString & )>(_a, &CourseManager::courseDetailsLoaded, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)(const QString & )>(_a, &CourseManager::courseCreated, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)(const QString & )>(_a, &CourseManager::courseUpdated, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)(const QString & )>(_a, &CourseManager::courseDeleted, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)(const QString & , bool )>(_a, &CourseManager::enrollmentStatusChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (CourseManager::*)(const QString & )>(_a, &CourseManager::apiError, 9))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->allCourses(); break;
        case 1: *reinterpret_cast<QVariantList*>(_v) = _t->myCourses(); break;
        case 2: *reinterpret_cast<QVariantList*>(_v) = _t->createdCourses(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->isLoading(); break;
        default: break;
        }
    }
}

const QMetaObject *CourseManager::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CourseManager::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13CourseManagerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int CourseManager::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 22)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 22;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 22)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 22;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void CourseManager::allCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void CourseManager::myCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void CourseManager::createdCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void CourseManager::isLoadingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void CourseManager::courseDetailsLoaded(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void CourseManager::courseCreated(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void CourseManager::courseUpdated(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void CourseManager::courseDeleted(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void CourseManager::enrollmentStatusChanged(const QString & _t1, bool _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1, _t2);
}

// SIGNAL 9
void CourseManager::apiError(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1);
}
QT_WARNING_POP
