# Config.pri file version 2.0. Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR = $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(debug, debug|release) {
        profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        } else {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }

    }

    CONFIG(release, debug|release) {
        !profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

simulator {
    CONFIG(debug, debug|release) {
        !profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

config_pri_assets {
    OTHER_FILES += \
        $$quote($$BASEDIR/assets/api.js) \
        $$quote($$BASEDIR/assets/common/Common.qml) \
        $$quote($$BASEDIR/assets/components/Carousel.qml) \
        $$quote($$BASEDIR/assets/components/RefreshHeader.qml) \
        $$quote($$BASEDIR/assets/images/bb10/ic_contact.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_deselect_all.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_diagnostics.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_favorite.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_help.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_home.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_info.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_search.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_settings.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_share.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_sort.png) \
        $$quote($$BASEDIR/assets/images/bb10/ic_textmessage_dk.png) \
        $$quote($$BASEDIR/assets/images/carousel/round_white.png) \
        $$quote($$BASEDIR/assets/images/comment_empty.png) \
        $$quote($$BASEDIR/assets/images/comment_vote.png) \
        $$quote($$BASEDIR/assets/main.qml) \
        $$quote($$BASEDIR/assets/pages/before.qml) \
        $$quote($$BASEDIR/assets/pages/child/CommentList.qml) \
        $$quote($$BASEDIR/assets/pages/comments.qml) \
        $$quote($$BASEDIR/assets/pages/hot.qml) \
        $$quote($$BASEDIR/assets/pages/index.qml) \
        $$quote($$BASEDIR/assets/pages/news.qml) \
        $$quote($$BASEDIR/assets/pages/sections.qml) \
        $$quote($$BASEDIR/assets/pages/themes.qml) \
        $$quote($$BASEDIR/assets/source/newsInjector.js) \
        $$quote($$BASEDIR/assets/source/news_qa.min.css) \
        $$quote($$BASEDIR/assets/source/zepto.min.js)
}

config_pri_source_group1 {
    SOURCES += \
        $$quote($$BASEDIR/src/Misc/Misc.cpp) \
        $$quote($$BASEDIR/src/Requester/Requester.cpp) \
        $$quote($$BASEDIR/src/WebImageView/WebImageView.cpp) \
        $$quote($$BASEDIR/src/applicationui.cpp) \
        $$quote($$BASEDIR/src/main.cpp)

    HEADERS += \
        $$quote($$BASEDIR/src/Misc/Misc.hpp) \
        $$quote($$BASEDIR/src/Requester/Requester.hpp) \
        $$quote($$BASEDIR/src/WebImageView/WebImageView.hpp) \
        $$quote($$BASEDIR/src/applicationui.hpp)
}

CONFIG += precompile_header

PRECOMPILED_HEADER = $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES += \
        $$quote($$BASEDIR/../src/*.c) \
        $$quote($$BASEDIR/../src/*.c++) \
        $$quote($$BASEDIR/../src/*.cc) \
        $$quote($$BASEDIR/../src/*.cpp) \
        $$quote($$BASEDIR/../src/*.cxx) \
        $$quote($$BASEDIR/../src/Misc/*.c) \
        $$quote($$BASEDIR/../src/Misc/*.c++) \
        $$quote($$BASEDIR/../src/Misc/*.cc) \
        $$quote($$BASEDIR/../src/Misc/*.cpp) \
        $$quote($$BASEDIR/../src/Misc/*.cxx) \
        $$quote($$BASEDIR/../src/Requester/*.c) \
        $$quote($$BASEDIR/../src/Requester/*.c++) \
        $$quote($$BASEDIR/../src/Requester/*.cc) \
        $$quote($$BASEDIR/../src/Requester/*.cpp) \
        $$quote($$BASEDIR/../src/Requester/*.cxx) \
        $$quote($$BASEDIR/../src/WebImageView/*.c) \
        $$quote($$BASEDIR/../src/WebImageView/*.c++) \
        $$quote($$BASEDIR/../src/WebImageView/*.cc) \
        $$quote($$BASEDIR/../src/WebImageView/*.cpp) \
        $$quote($$BASEDIR/../src/WebImageView/*.cxx) \
        $$quote($$BASEDIR/../assets/*.qml) \
        $$quote($$BASEDIR/../assets/*.js) \
        $$quote($$BASEDIR/../assets/*.qs) \
        $$quote($$BASEDIR/../assets/common/*.qml) \
        $$quote($$BASEDIR/../assets/common/*.js) \
        $$quote($$BASEDIR/../assets/common/*.qs) \
        $$quote($$BASEDIR/../assets/components/*.qml) \
        $$quote($$BASEDIR/../assets/components/*.js) \
        $$quote($$BASEDIR/../assets/components/*.qs) \
        $$quote($$BASEDIR/../assets/images/*.qml) \
        $$quote($$BASEDIR/../assets/images/*.js) \
        $$quote($$BASEDIR/../assets/images/*.qs) \
        $$quote($$BASEDIR/../assets/images/bb10/*.qml) \
        $$quote($$BASEDIR/../assets/images/bb10/*.js) \
        $$quote($$BASEDIR/../assets/images/bb10/*.qs) \
        $$quote($$BASEDIR/../assets/images/carousel/*.qml) \
        $$quote($$BASEDIR/../assets/images/carousel/*.js) \
        $$quote($$BASEDIR/../assets/images/carousel/*.qs) \
        $$quote($$BASEDIR/../assets/pages/*.qml) \
        $$quote($$BASEDIR/../assets/pages/*.js) \
        $$quote($$BASEDIR/../assets/pages/*.qs) \
        $$quote($$BASEDIR/../assets/pages/child/*.qml) \
        $$quote($$BASEDIR/../assets/pages/child/*.js) \
        $$quote($$BASEDIR/../assets/pages/child/*.qs) \
        $$quote($$BASEDIR/../assets/sheets/*.qml) \
        $$quote($$BASEDIR/../assets/sheets/*.js) \
        $$quote($$BASEDIR/../assets/sheets/*.qs) \
        $$quote($$BASEDIR/../assets/source/*.qml) \
        $$quote($$BASEDIR/../assets/source/*.js) \
        $$quote($$BASEDIR/../assets/source/*.qs)

    HEADERS += \
        $$quote($$BASEDIR/../src/*.h) \
        $$quote($$BASEDIR/../src/*.h++) \
        $$quote($$BASEDIR/../src/*.hh) \
        $$quote($$BASEDIR/../src/*.hpp) \
        $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS = $$quote($${TARGET}.ts)
