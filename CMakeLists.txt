cmake_minimum_required(VERSION 3.23)

project(MyProjectName)

add_executable(MyProgram)

find_package(KF6 REQUIRED COMPONENTS StatusNotifierItem)
target_link_libraries(mytarget PRIVATE KF6::StatusNotifierItem)

target_sources(MyProgram
  PRIVATE
    main.qt_wrap_cpp()
)
