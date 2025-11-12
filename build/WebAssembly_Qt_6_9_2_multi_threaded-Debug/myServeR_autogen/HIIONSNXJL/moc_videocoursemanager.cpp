/****************************************************************************
** Meta object code from reading C++ file 'videocoursemanager.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../H/videocoursemanager.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'videocoursemanager.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN18VideoCourseManagerE_t {};
} // unnamed namespace

template <> constexpr inline auto VideoCourseManager::qt_create_metaobjectdata<qt_meta_tag_ZN18VideoCourseManagerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "VideoCourseManager",
        "allCoursesChanged",
        "",
        "myCoursesChanged",
        "createdCoursesChanged",
        "courseCreated",
        "courseId",
        "courseUpdated",
        "courseDeleted",
        "courseEnrolled",
        "courseProgressUpdated",
        "progress",
        "createCourse",
        "QVariantMap",
        "courseData",
        "enrollInCourse",
        "leaveCourse",
        "updateCourseProgress",
        "deleteCourse",
        "updateCourse",
        "getCourse",
        "addLesson",
        "lessonData",
        "removeLesson",
        "lessonId",
        "getCoursesByAuthor",
        "QVariantList",
        "authorId",
        "getAllAuthors",
        "getCourseProgress",
        "searchCourses",
        "query",
        "getCoursesByChannelId",
        "getCoursesByCategory",
        "category",
        "getRecommendedCourses",
        "allCourses",
        "myCourses",
        "createdCourses"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'allCoursesChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'myCoursesChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'createdCoursesChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'courseCreated'
        QtMocHelpers::SignalData<void(const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Signal 'courseUpdated'
        QtMocHelpers::SignalData<void(const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Signal 'courseDeleted'
        QtMocHelpers::SignalData<void(const QString &)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Signal 'courseEnrolled'
        QtMocHelpers::SignalData<void(const QString &)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Signal 'courseProgressUpdated'
        QtMocHelpers::SignalData<void(const QString &, int)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { QMetaType::Int, 11 },
        }}),
        // Method 'createCourse'
        QtMocHelpers::MethodData<void(const QVariantMap &)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 13, 14 },
        }}),
        // Method 'enrollInCourse'
        QtMocHelpers::MethodData<void(const QString &)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'leaveCourse'
        QtMocHelpers::MethodData<void(const QString &)>(16, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'updateCourseProgress'
        QtMocHelpers::MethodData<void(const QString &, int)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { QMetaType::Int, 11 },
        }}),
        // Method 'deleteCourse'
        QtMocHelpers::MethodData<void(const QString &)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'updateCourse'
        QtMocHelpers::MethodData<void(const QString &, const QVariantMap &)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { 0x80000000 | 13, 14 },
        }}),
        // Method 'getCourse'
        QtMocHelpers::MethodData<QVariantMap(const QString &) const>(20, 2, QMC::AccessPublic, 0x80000000 | 13, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'addLesson'
        QtMocHelpers::MethodData<void(const QString &, const QVariantMap &)>(21, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { 0x80000000 | 13, 22 },
        }}),
        // Method 'removeLesson'
        QtMocHelpers::MethodData<void(const QString &, const QString &)>(23, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { QMetaType::QString, 24 },
        }}),
        // Method 'getCoursesByAuthor'
        QtMocHelpers::MethodData<QVariantList(const QString &) const>(25, 2, QMC::AccessPublic, 0x80000000 | 26, {{
            { QMetaType::QString, 27 },
        }}),
        // Method 'getAllAuthors'
        QtMocHelpers::MethodData<QVariantList() const>(28, 2, QMC::AccessPublic, 0x80000000 | 26),
        // Method 'getCourseProgress'
        QtMocHelpers::MethodData<QVariantMap(const QString &) const>(29, 2, QMC::AccessPublic, 0x80000000 | 13, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'searchCourses'
        QtMocHelpers::MethodData<QVariantList(const QString &) const>(30, 2, QMC::AccessPublic, 0x80000000 | 26, {{
            { QMetaType::QString, 31 },
        }}),
        // Method 'getCoursesByChannelId'
        QtMocHelpers::MethodData<QVariantList(const QString &) const>(32, 2, QMC::AccessPublic, 0x80000000 | 26, {{
            { QMetaType::QString, 27 },
        }}),
        // Method 'getCoursesByCategory'
        QtMocHelpers::MethodData<QVariantList(const QString &) const>(33, 2, QMC::AccessPublic, 0x80000000 | 26, {{
            { QMetaType::QString, 34 },
        }}),
        // Method 'getRecommendedCourses'
        QtMocHelpers::MethodData<QVariantList() const>(35, 2, QMC::AccessPublic, 0x80000000 | 26),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'allCourses'
        QtMocHelpers::PropertyData<QVariantList>(36, 0x80000000 | 26, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'myCourses'
        QtMocHelpers::PropertyData<QVariantList>(37, 0x80000000 | 26, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'createdCourses'
        QtMocHelpers::PropertyData<QVariantList>(38, 0x80000000 | 26, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<VideoCourseManager, qt_meta_tag_ZN18VideoCourseManagerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject VideoCourseManager::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18VideoCourseManagerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18VideoCourseManagerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN18VideoCourseManagerE_t>.metaTypes,
    nullptr
} };

void VideoCourseManager::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<VideoCourseManager *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->allCoursesChanged(); break;
        case 1: _t->myCoursesChanged(); break;
        case 2: _t->createdCoursesChanged(); break;
        case 3: _t->courseCreated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: _t->courseUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 5: _t->courseDeleted((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 6: _t->courseEnrolled((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 7: _t->courseProgressUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 8: _t->createCourse((*reinterpret_cast< std::add_pointer_t<QVariantMap>>(_a[1]))); break;
        case 9: _t->enrollInCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 10: _t->leaveCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: _t->updateCourseProgress((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 12: _t->deleteCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 13: _t->updateCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QVariantMap>>(_a[2]))); break;
        case 14: { QVariantMap _r = _t->getCourse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 15: _t->addLesson((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QVariantMap>>(_a[2]))); break;
        case 16: _t->removeLesson((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2]))); break;
        case 17: { QVariantList _r = _t->getCoursesByAuthor((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 18: { QVariantList _r = _t->getAllAuthors();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 19: { QVariantMap _r = _t->getCourseProgress((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 20: { QVariantList _r = _t->searchCourses((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 21: { QVariantList _r = _t->getCoursesByChannelId((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 22: { QVariantList _r = _t->getCoursesByCategory((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 23: { QVariantList _r = _t->getRecommendedCourses();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)()>(_a, &VideoCourseManager::allCoursesChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)()>(_a, &VideoCourseManager::myCoursesChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)()>(_a, &VideoCourseManager::createdCoursesChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)(const QString & )>(_a, &VideoCourseManager::courseCreated, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)(const QString & )>(_a, &VideoCourseManager::courseUpdated, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)(const QString & )>(_a, &VideoCourseManager::courseDeleted, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)(const QString & )>(_a, &VideoCourseManager::courseEnrolled, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoCourseManager::*)(const QString & , int )>(_a, &VideoCourseManager::courseProgressUpdated, 7))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->allCourses(); break;
        case 1: *reinterpret_cast<QVariantList*>(_v) = _t->myCourses(); break;
        case 2: *reinterpret_cast<QVariantList*>(_v) = _t->createdCourses(); break;
        default: break;
        }
    }
}

const QMetaObject *VideoCourseManager::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *VideoCourseManager::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18VideoCourseManagerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int VideoCourseManager::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 24)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 24;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 24)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 24;
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
void VideoCourseManager::allCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void VideoCourseManager::myCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void VideoCourseManager::createdCoursesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void VideoCourseManager::courseCreated(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void VideoCourseManager::courseUpdated(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void VideoCourseManager::courseDeleted(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void VideoCourseManager::courseEnrolled(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void VideoCourseManager::courseProgressUpdated(const QString & _t1, int _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1, _t2);
}
QT_WARNING_POP
