cmake_minimum_required(VERSION 3.23)

project(Kaffeine LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(Qt6 REQUIRED COMPONENTS Widgets Core)
find_package(Qt6 REQUIRED COMPONENTS Widgets)
find_package(KF6StatusNotifierItem REQUIRED)

add_executable(Kaffeine
    main.cpp
    src/app/app.cpp
    src/app/trayIcon.cpp
    src/warningHandler.cpp
)

target_link_libraries(Kaffeine PRIVATE
    Qt6::Core
    Qt6::Widgets
    KF6::StatusNotifierItem
)

qt_add_resources(Kaffeine "assets"
    PREFIX "/"
    FILES
        assets/coffee_dark_on.png
)