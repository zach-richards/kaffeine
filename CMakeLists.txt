cmake_minimum_required(VERSION 3.23)
project(Kaffeine)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
find_package(Plasma REQUIRED)

plasma_install_package(package ${PLUGIN_ID})