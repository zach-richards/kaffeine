cmake_minimum_required(VERSION 3.23)

project(Kaffeine LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets Core)
find_package(Qt6 REQUIRED COMPONENTS Widgets)
find_package(KF6StatusNotifierItem REQUIRED)

add_executable(Kaffeine main.cpp)

target_link_libraries(Kaffeine PRIVATE
    Qt6::Core
    Qt6::Widgets
    KF6::StatusNotifierItem
)