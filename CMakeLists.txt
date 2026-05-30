cmake_minimum_required(VERSION 3.23)

project(Kaffeine VERSION 0.1 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Widgets)
find_package(KF6StatusNotifierItem REQUIRED)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(Kaffeine
    main.cpp
)

target_link_libraries(Kaffeine PRIVATE
    Qt6::Widgets
    KF6::StatusNotifierItem
)