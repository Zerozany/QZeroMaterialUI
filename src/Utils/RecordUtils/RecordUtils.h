_Pragma("once");
#include <QObject>
#include <QtQml>

#if defined(Q_OS_WINDOWS) && defined(_MSC_VER)
    #ifdef QZeroMaterialUI
        #define QZERO_API Q_DECL_EXPORT
    #else
        #define QZERO_API Q_DECL_IMPORT
    #endif
#elif defined(__GNUC__) || defined(__clang__)
    #define QZERO_API __attribute__((visibility("default")))
#else
    #define QZERO_API
#endif

class RecordUtils : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
public:
    static RecordUtils* create(QQmlEngine*, QJSEngine*);

    ~RecordUtils() noexcept = default;

    Q_DISABLE_COPY_MOVE(RecordUtils)

public:
protected:
    explicit(true) RecordUtils(QObject* _parent = nullptr);
};
