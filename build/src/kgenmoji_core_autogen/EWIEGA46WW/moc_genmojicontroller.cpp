/****************************************************************************
** Meta object code from reading C++ file 'genmojicontroller.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.12.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/genmojicontroller.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'genmojicontroller.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.12.0. It"
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
struct qt_meta_tag_ZN17GenmojiControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto GenmojiController::qt_create_metaobjectdata<qt_meta_tag_ZN17GenmojiControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "GenmojiController",
        "generatingChanged",
        "",
        "statusMessageChanged",
        "currentStickerPathChanged",
        "recentStickersChanged",
        "curatedMashupsChanged",
        "currentMashupUrlChanged",
        "stickerReady",
        "filePath",
        "onDownloadFinished",
        "QNetworkReply*",
        "reply",
        "generateAiSticker",
        "prompt",
        "style",
        "selectMashup",
        "index",
        "copyToClipboard",
        "imagePath",
        "copyMashupToClipboard",
        "imageUrl",
        "deleteSticker",
        "openStickersFolder",
        "refreshRecentStickers",
        "isGenerating",
        "statusMessage",
        "currentStickerPath",
        "recentStickers",
        "QVariantList",
        "curatedMashups",
        "currentMashupUrl"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'generatingChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'statusMessageChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'currentStickerPathChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'recentStickersChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'curatedMashupsChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'currentMashupUrlChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'stickerReady'
        QtMocHelpers::SignalData<void(const QString &)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 9 },
        }}),
        // Slot 'onDownloadFinished'
        QtMocHelpers::SlotData<void(QNetworkReply *)>(10, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 11, 12 },
        }}),
        // Method 'generateAiSticker'
        QtMocHelpers::MethodData<void(const QString &, const QString &)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::QString, 15 },
        }}),
        // Method 'generateAiSticker'
        QtMocHelpers::MethodData<void(const QString &)>(13, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'selectMashup'
        QtMocHelpers::MethodData<void(int)>(16, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 17 },
        }}),
        // Method 'copyToClipboard'
        QtMocHelpers::MethodData<void(const QString &)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 19 },
        }}),
        // Method 'copyMashupToClipboard'
        QtMocHelpers::MethodData<void(const QString &)>(20, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 21 },
        }}),
        // Method 'deleteSticker'
        QtMocHelpers::MethodData<void(const QString &)>(22, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 19 },
        }}),
        // Method 'openStickersFolder'
        QtMocHelpers::MethodData<void()>(23, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'refreshRecentStickers'
        QtMocHelpers::MethodData<void()>(24, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'isGenerating'
        QtMocHelpers::PropertyData<bool>(25, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'statusMessage'
        QtMocHelpers::PropertyData<QString>(26, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'currentStickerPath'
        QtMocHelpers::PropertyData<QString>(27, QMetaType::QString, QMC::DefaultPropertyFlags, 2),
        // property 'recentStickers'
        QtMocHelpers::PropertyData<QVariantList>(28, 0x80000000 | 29, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 3),
        // property 'curatedMashups'
        QtMocHelpers::PropertyData<QVariantList>(30, 0x80000000 | 29, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 4),
        // property 'currentMashupUrl'
        QtMocHelpers::PropertyData<QString>(31, QMetaType::QString, QMC::DefaultPropertyFlags, 5),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<GenmojiController, qt_meta_tag_ZN17GenmojiControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject GenmojiController::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN17GenmojiControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN17GenmojiControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN17GenmojiControllerE_t>.metaTypes,
    nullptr
} };

void GenmojiController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<GenmojiController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->generatingChanged(); break;
        case 1: _t->statusMessageChanged(); break;
        case 2: _t->currentStickerPathChanged(); break;
        case 3: _t->recentStickersChanged(); break;
        case 4: _t->curatedMashupsChanged(); break;
        case 5: _t->currentMashupUrlChanged(); break;
        case 6: _t->stickerReady((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 7: _t->onDownloadFinished((*reinterpret_cast<std::add_pointer_t<QNetworkReply*>>(_a[1]))); break;
        case 8: _t->generateAiSticker((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 9: _t->generateAiSticker((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 10: _t->selectMashup((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 11: _t->copyToClipboard((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->copyMashupToClipboard((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 13: _t->deleteSticker((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 14: _t->openStickersFolder(); break;
        case 15: _t->refreshRecentStickers(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 7:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply* >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)()>(_a, &GenmojiController::generatingChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)()>(_a, &GenmojiController::statusMessageChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)()>(_a, &GenmojiController::currentStickerPathChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)()>(_a, &GenmojiController::recentStickersChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)()>(_a, &GenmojiController::curatedMashupsChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)()>(_a, &GenmojiController::currentMashupUrlChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (GenmojiController::*)(const QString & )>(_a, &GenmojiController::stickerReady, 6))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<bool*>(_v) = _t->isGenerating(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->statusMessage(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->currentStickerPath(); break;
        case 3: *reinterpret_cast<QVariantList*>(_v) = _t->recentStickers(); break;
        case 4: *reinterpret_cast<QVariantList*>(_v) = _t->curatedMashups(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->currentMashupUrl(); break;
        default: break;
        }
    }
}

const QMetaObject *GenmojiController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *GenmojiController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN17GenmojiControllerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int GenmojiController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void GenmojiController::generatingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void GenmojiController::statusMessageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void GenmojiController::currentStickerPathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void GenmojiController::recentStickersChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void GenmojiController::curatedMashupsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void GenmojiController::currentMashupUrlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void GenmojiController::stickerReady(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}
QT_WARNING_POP
