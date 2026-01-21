#include "ThemeManager.h"
#include <QSettings>

ThemeManager* ThemeManager::create(QQmlEngine*, QJSEngine*)
{
    static ThemeManager* themesSetting{new ThemeManager{}};
    return themesSetting;
}

ThemeManager::ThemeManager(QObject* _parent) : QObject{_parent}
{
    std::invoke(&ThemeManager::init, this);
    std::invoke(&ThemeManager::connectSignal2Slot, this);
    std::invoke(&ThemeManager::setInitTheme, this);
}

auto ThemeManager::init() noexcept -> void
{
    std::invoke(&ThemeManager::setLightTheme, this);
    std::invoke(&ThemeManager::setDarkTheme, this);
}

auto ThemeManager::setInitTheme() noexcept -> void
{
    QSettings settings{m_themeConfigDir, QSettings::IniFormat};
    settings.beginGroup("Theme");
    if (!settings.contains("ThemeName"))
    {
        settings.setValue("ThemeName", "Light");
    }
    this->setCurrentThemeName(settings.value("ThemeName").toString());
    settings.endGroup();
}

auto ThemeManager::getThemesList() noexcept -> QStringList
{
    m_themesList.clear();
    for (const QFileInfo& info : m_themesDir.entryInfoList({"*.ini"}, QDir::Files | QDir::NoDotAndDotDot))
    {
        m_themesList << info.baseName();
    }
    return m_themesList;
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
        tmpThemeMap["BackgroundColor"] = settings.value("BackgroundColor", m_lightTheme["BackgroundColor"]);
        tmpThemeMap["TextColor"]       = settings.value("TextColor", m_lightTheme["TextColor"]);
        tmpThemeMap["ButtonColor"]     = settings.value("ButtonColor", m_lightTheme["ButtonColor"]);
        tmpThemeMap["ElementColor"]    = settings.value("ElementColor", m_lightTheme["ElementColor"]);
        tmpThemeMap["LabelColor"]      = settings.value("LabelColor", m_lightTheme["LabelColor"]);
        settings.endGroup();
        return tmpThemeMap;
    }};

    this->setCurrentTheme(readConfigTheme(this->m_currentThemeName));
    QSettings settings{m_themeConfigDir, QSettings::IniFormat};
    settings.beginGroup("Theme");
    settings.setValue("ThemeName", this->m_currentThemeName);
    settings.endGroup();
    settings.sync();
}

auto ThemeManager::setLightTheme() noexcept -> void
{
    QSettings settings{m_themesDir.filePath(QString("%1.ini").arg("Light")), QSettings::IniFormat};
    settings.beginGroup("Colors");
    if (!settings.contains("BackgroundColor"))
    {
        settings.setValue("BackgroundColor", m_lightTheme["BackgroundColor"]);
    }
    if (!settings.contains("TextColor"))
    {
        settings.setValue("TextColor", m_lightTheme["TextColor"]);
    }
    if (!settings.contains("ButtonColor"))
    {
        settings.setValue("ButtonColor", m_lightTheme["ButtonColor"]);
    }
    if (!settings.contains("ElementColor"))
    {
        settings.setValue("ElementColor", m_lightTheme["ElementColor"]);
    }
    if (!settings.contains("LabelColor"))
    {
        settings.setValue("LabelColor", m_lightTheme["LabelColor"]);
    }
    settings.endGroup();
    settings.sync();
}

auto ThemeManager::setDarkTheme() noexcept -> void
{
    QSettings settings{m_themesDir.filePath(QString("%1.ini").arg("Dark")), QSettings::IniFormat};
    settings.beginGroup("Colors");
    if (!settings.contains("BackgroundColor"))
    {
        settings.setValue("BackgroundColor", m_darkTheme["BackgroundColor"]);
    }
    if (!settings.contains("TextColor"))
    {
        settings.setValue("TextColor", m_darkTheme["TextColor"]);
    }
    if (!settings.contains("ButtonColor"))
    {
        settings.setValue("ButtonColor", m_darkTheme["ButtonColor"]);
    }
    if (!settings.contains("ElementColor"))
    {
        settings.setValue("ElementColor", m_darkTheme["ElementColor"]);
    }
    if (!settings.contains("LabelColor"))
    {
        settings.setValue("LabelColor", m_darkTheme["LabelColor"]);
    }
    settings.endGroup();
    settings.sync();
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
