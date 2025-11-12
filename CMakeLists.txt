cmake_minimum_required(VERSION 3.16)

project(myServeR VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Optimize flags
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -flto -fno-exceptions")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -O3 -flto")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif()

# Determine required Qt components based on target
if(EMSCRIPTEN)
    # WebAssembly: NetworkAuth is NOT available
    set(QT_COMPONENTS Core Quick QuickControls2 Network Sql)
else()
    # Desktop/native: include NetworkAuth
    set(QT_COMPONENTS Core Quick QuickControls2 Network Sql NetworkAuth)
endif()

find_package(Qt6 REQUIRED COMPONENTS ${QT_COMPONENTS})

qt_standard_project_setup()

qt_add_executable(myServeR
  main.cpp
  CPP/database.cpp
  CPP/navigationhistory.cpp
  CPP/profilemanager.cpp
  CPP/thememanager.cpp
  CPP/videocoursemanager.cpp
  CPP/googleauth.cpp
  CPP/channelmanager.cpp
  CPP/course.cpp
  CPP/lesson.cpp
  CPP/coursedetails.cpp
  CPP/coursemanager.cpp
)

qt_policy(SET QTP0001 NEW)

qt_add_resources(myServeR "resources"
    PREFIX "/"
    FILES
        icons/menu-icon.webp
        icons/back_icon.webp
        icons/forward.webp
        icons/profile-icon.webp
        icons/search-icon.webp
        icons/settings_panel_icon.webp
        icons/sidebar_icon.webp
        icons/home-house.webp
        icons/left_icon.webp
        icons/right_icon.webp
        icons/add_mark_icon.webp
        icons/like_icon.webp
        icons/release_overview_icon.webp
        icons/fail_icon.webp
        icons/icon_standard.webp
        icons/delete-icon.webp
        icons/edit_pen_icon.webp
        icons/photocamera_icon.webp
        icons/google-icon.webp

        images/javascriptLogo.webp
        images/pythonLogo.webp
        images/plugImage.webp
        images/javascript.webp
        images/python.webp
        images/preview_standard.webp
        images/proud-confident.webp
        images/pointing-present.webp
        images/pointing-at-camera.webp
        images/hands-together-point.webp
        images/showing-and-pointing.webp
        images/confused-thinking.webp
        images/confused-casual.webp
        images/shows-thumbs.webp
)

qt_add_qml_module(myServeR
    URI myQML
    VERSION 1.0
    QML_FILES
        QML/Main.qml
        QML/LoginPage.qml
        QML/RegisterPage.qml
        QML/MainPage.qml
        QML/CardCourse.qml
        QML/MainSearchPage.qml
        QML/CardVideoListView.qml
        QML/SearchTagInput.qml
        QML/CardVideo.qml
        QML/VideoMainDesktop.qml
        QML/VideoMainWasm.qml
        QML/JSONListModel.qml
        QML/VideoPlayer.qml
        QML/VideoMainAndroid.qml
        QML/ProfilePage.qml
        QML/SettingsPage.qml
        QML/ProfileСhannel.qml
        QML/ColorButton.qml
        QML/ProfileBlock/ProfileBlock.qml
        QML/ProfileBlock/ContactBlock.qml
        QML/ProfileBlock/InformationBlock.qml
        QML/ProfileBlock/StatusBlock.qml
        QML/ProfileBlock/ProjectBlock.qml
        QML/ProfileBlock/VideoCourseBlock.qml
        QML/ProfileBlock/VideoManagementBlock.qml
        QML/AuthPage.qml
        QML/CourseListBlock.qml
        QML/CardCourseProfile.qml
        H/database.h
        H/navigationhistory.h
        H/profilemanager.h
        H/thememanager.h
        H/videocoursemanager.h
        H/googleauth.h
        H/channelmanager.h
        H/course.h
        H/lesson.h
        H/coursedetails.h
        H/coursemanager.h
)

# Link Qt libraries conditionally
target_link_libraries(myServeR PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Network
    Qt6::Sql
)

# Only link NetworkAuth if available (non-wasm builds)
if(TARGET Qt6::NetworkAuth)
    target_link_libraries(myServeR PRIVATE Qt6::NetworkAuth)
endif()

include(CPack)
