#include "ThemeManager.h"
#include <QSettings>
#include <ranges>

static constexpr const char* LIGHTFILENAME{"Light"};
static constexpr const char* DARDFILENAME{"Dark"};

ThemeManager* ThemeManager::create(QQmlEngine*, QJSEngine*)
{
    static ThemeManager* themesSetting{new ThemeManager{}};
    return themesSetting;
}

ThemeManager::ThemeManager(QObject* _parent) : QObject{_parent}
{
    std::invoke(&ThemeManager::init, this);
    std::invoke(&ThemeManager::connectSignal2Slot, this);
    std::invoke(&ThemeManager::initThemeConfig, this);
}

auto ThemeManager::init() noexcept -> void
{
    std::invoke(&ThemeManager::setLightTheme, this);
    std::invoke(&ThemeManager::setDarkTheme, this);
}

auto ThemeManager::initThemeConfig() noexcept -> void
{
    QSettings settings{m_themeConfigDir, QSettings::IniFormat};
    settings.beginGroup("Theme");
    if (!settings.contains("ThemeName"))
    {
        settings.setValue("ThemeName", LIGHTFILENAME);
    }
    this->setCurrentThemeName(settings.value("ThemeName").toString());
    settings.endGroup();
}

QStringList ThemeManager::getThemesList()
{
    QStringList tmpThemesList{};
    for (const QFileInfo& info : m_themesDir.entryInfoList({"*.ini"}, QDir::Files | QDir::NoDotAndDotDot))
    {
        tmpThemesList << info.baseName();
    }
    return tmpThemesList;
}

auto ThemeManager::connectSignal2Slot() noexcept -> void
{
    connect(this, &ThemeManager::currentThemeNameChanged, this, &ThemeManager::onCurrentThemeNameChanged, Qt::AutoConnection);
}

void ThemeManager::onCurrentThemeNameChanged()
{
    auto readConfigTheme{[this](const QString& _themeName) -> QVariantMap {
        QVariantMap tmpThemeMap{};
        QSettings   settings{m_themesDir.filePath(QString("%1.ini").arg(_themeName)), QSettings::IniFormat};
        settings.beginGroup("Colors");
        for (const auto& key : m_lightTheme.toStdMap() | std::views::keys)
        {
            tmpThemeMap[key] = settings.value(key, m_lightTheme[key]);
        }
        settings.endGroup();
        return tmpThemeMap;
    }};

    this->setCurrentTheme(readConfigTheme(this->m_currentThemeName));
    QSettings settings{m_themeConfigDir, QSettings::IniFormat};
    settings.beginGroup("Theme");
    settings.setValue("ThemeName", this->m_currentThemeName);
    settings.endGroup();
}

auto ThemeManager::setLightTheme() noexcept -> void
{
    QSettings settings{m_themesDir.filePath(QString("%1.ini").arg(LIGHTFILENAME)), QSettings::IniFormat};
    settings.beginGroup("Colors");
    for (const auto& key : m_lightTheme.toStdMap() | std::views::keys)
    {
        if (!settings.contains(key))
        {
            settings.setValue(key, m_lightTheme[key]);
        }
    }
    settings.endGroup();
}

auto ThemeManager::setDarkTheme() noexcept -> void
{
    QSettings settings{m_themesDir.filePath(QString("%1.ini").arg(DARDFILENAME)), QSettings::IniFormat};
    settings.beginGroup("Colors");
    for (const auto& key : m_lightTheme.toStdMap() | std::views::keys)
    {
        if (!settings.contains(key))
        {
            settings.setValue(key, m_darkTheme[key]);
        }
    }
    settings.endGroup();
}

QVariantMap ThemeManager::currentTheme() const
{
    return this->m_currentTheme;
}

void ThemeManager::setCurrentTheme(const QVariantMap& _currentTheme)
{
    if (m_currentTheme == _currentTheme)
    {
        return;
    }
    m_currentTheme = _currentTheme;
    Q_EMIT this->currentThemeChanged();
}

QString ThemeManager::currentThemeName() const
{
    return this->m_currentThemeName;
}

void ThemeManager::setCurrentThemeName(const QString& _currentThemeName)
{
    if (m_currentThemeName == _currentThemeName)
    {
        return;
    }
    m_currentThemeName = _currentThemeName;
    Q_EMIT this->currentThemeNameChanged();
}
