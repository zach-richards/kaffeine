cmake_minimum_required(VERSION 3.23)
project(Kaffeine)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Plasma REQUIRED)

set(PLUGIN_ID "org.kde.kaffeine")

install(DIRECTORY package/
    DESTINATION ${KDE_INSTALL_DATADIR}/plasma/plasmoids/${PLUGIN_ID}
)