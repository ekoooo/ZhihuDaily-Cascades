import bb.cascades 1.4
import "asset:///api.js" as Api

QtObject {
    property variant api: Api.Api
    property variant bbwAddr: "appworld://content/60017887"
    property variant developerEmail: "954408050@qq.com"
    property variant version:  Application.applicationVersion
    property variant hardwareInfo: _misc.getHardwareInfo()
    
    // 设置 key
    property variant settingsKey: {
        // 主题
        "theme": "theme",
        // 文章大字体
        "newsLargeFont": "newsLargeFont",
        // 文章护眼模式
        "newsEyeProtectionModel":"newsEyeProtectionModel",
        // 是否显示返回按钮
        "backButtonVisiable": "backButtonVisiable",
        // 开发者消息版本
        "developerMessageVersion": "developerMessageVersion"
    }
    
    // 快捷键
    property variant shortCutKey: {
        "shortCutList": ['back', 'indexPage', 'hotPage', 'sectionsPage', 'themesPage', 'beforePage', 'commonPage', 'switchCommonType'],
                
         "back": "f",
         "backLabel": qsTr("返回"),
         "indexPage": "h",
         "indexPageLabel": qsTr("主页"),
         "hotPage": "r",
         "hotPageLabel": qsTr("今日热门"),
         "sectionsPage": "l",
         "sectionsPageLabel": qsTr("栏目分类"),
         "themesPage": "z",
         "themesPageLabel": qsTr("主题日报"),
         "beforePage": "g",
         "beforePageLabel": qsTr("过往文章"),
         "commonPage": "c",
         "commonPageLabel": qsTr("进入评论页面"),
         "switchCommonType": "c",
         "switchCommonTypeLabel": qsTr("切换长短评")
    }
    
    /**
     * 验证 20180723 格式
     */
    function checkDateStr(dateStr) {
        return dateStr && typeof dateStr === 'string' && dateStr.length === 8;
    }
    
    /**
     * 格式化，20180723 -> 2018/07/23
     */
    function formatDateStr(dateStr, splitStr) {
        if(!checkDateStr(dateStr)) {
            return 'error';
        }
        
        splitStr = splitStr || '/';
        var info = [];
        info.push(dateStr.substring(0, 4));
        info.push(dateStr.substring(4, 6));
        info.push(dateStr.substring(6, 8));
        
        return info.join(splitStr);
    }
    
    /**
     * 格式化，20180723 -> 星期X
     */
    function dateWeek(date) {
        if(!checkDateStr(date)) {
            return 'error';
        }
        return "星期" + "日一二三四五六".charAt(new Date(formatDateStr(date)).getDay());
    }
    
    /**
     * 获取日期信息
     * 年、月、日、时、分、秒
     */
    function getDateInfo(date) {
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var h = date.getHours();
        var m = date.getMinutes();
        var s = date.getSeconds();
        
        month = month < 10 ? '0' + month : month;
        day = day < 10 ? '0' + day : day;
        h = h < 10 ? '0' + h : h;
        m = m < 10 ? '0' + m : m;
        s = s < 10 ? '0' + s : s;
        
        return {
            year: year,
            month: month,
            day: day,
            h: h,
            m: m,
            s: s
        };
    }
    
    /**
     * 格式化时间戳
     * type: 
     *     1 e.g. 07-25 13:31
     *     2 e.g. 2018-07-26 16:35:04
     *     3 e.g. 20180726
     *     4 e.g. 2018/07/26
     */
    function formaTtimestamp(timestamp, type) {
        if(typeof timestamp === 'string') {
            timestamp = Number(timestamp);
        }
        if(timestamp <= 9999999999) {
            timestamp = timestamp * 1000;
        }
        
        var info = getDateInfo(new Date(timestamp));
        
        if(type == 1) {
            return info['month'] + '-' + info['day'] + ' ' + info['h'] + ':' + info['m'];
        }else if(type === 2) {
            return info['year'] + '-' +info['month'] + '-' + info['day'] + ' ' + info['h'] + ':' + info['m'] + ':' + info['s'];
        }else if(type === 3) {
            return info['year'] + '' +info['month'] + '' + info['day']
        }else if(type === 4) {
            return info['year'] + '/' +info['month'] + '/' + info['day']
        }
    }
    
    /**
     * 返回上一天日期字符串
     * 2018/07/26 => 20180725
     */
    function getPreDateStr(currentDateStr) {
        return formaTtimestamp(+new Date(currentDateStr) - 86400000, 3);
    }
    
    /**
     * 返回上一天日期字符串
     * 2018/07/26 => 20180727
     */
    function getNextDateStr(currentDateStr) {
        return formaTtimestamp(+new Date(currentDateStr) + 86400000, 3);
    }
    
    // 打开对话框
    function openDialog(title, body) {
        _misc.openDialog(qsTr("确定"), qsTr("取消"), title, body);
    }
    
    // ============ nav start ============
    function onPopTransitionEnded(nav, page) {
        page.destroy();
        
        if(page.objectName === 'sponsorInfoPage') {
            Application.menuEnabled = false;
        }else {
            Application.menuEnabled = true;
        }
    }
    
    function onPushTransitionEnded(nav, page) {
        // 帮助、赞助、关于、设置 页面禁止再打开 application menu
        Application.menuEnabled = ['helpPage', 'sponsorPage', 'aboutPage', 'settingsPage', 'sponsorInfoPage'].indexOf(page.objectName) === -1;
    }
    // ============ nav end ============
    
    // ============ api start ============
    // 主页列表
    function apiNewsLatest(requester) {
        requester.send(api.newsLatest);
    }
    // 主页列表加载更多
    function apiNewsBefore(requester, currentDate) {
        if(currentDate.indexOf('/') !== -1) {
            currentDate = formaTtimestamp(+new Date(currentDate), 3);
        }
        
        requester.send(qsTr(api.newsBefore).arg(currentDate));
    }
    // 文章内容
    function apiNews(requester, newsId) {
        requester.send(qsTr(api.news).arg(newsId.toString()));
    }
    // 文章额外信息
    function apiStoryExtra(requester, storyExtraRequester, newsId) {
        requester.send(qsTr(api.storyExtra).arg(newsId.toString()));
    }
    // 文章评论
    function apiComments(requester, api, newsId) {
        requester.send(qsTr(api).arg(newsId.toString()));
    }
    // 文章评论加载更多
    function apiCommentsMore(requester, api, newsId, lastCommentId) {
        requester.send(qsTr(api).arg(newsId.toString()).arg(lastCommentId.toString()));
    }
    // 栏目分类
    function apiSections(requester) {
        requester.send(api.sections);
    }
    // 栏目分类列表
    function apiSectionMore(requester, sectionId, dateStr) {
        var tsmp = +new Date(dateStr.indexOf('/') === -1 ? formatDateStr(dateStr) : dateStr) / 1000;
        requester.send(qsTr(api.sectionMore).arg(sectionId.toString()).arg(tsmp.toString()));
    }
    // 主题日报
    function apiThemes(requester) {
        requester.send(api.themes);
    }
    // 主题日报列表
    function apiThemeList(requester, themeId) {
        requester.send(qsTr(api.theme).arg(themeId.toString()));
    }
    // 主题日报更多
    function apiThemeListMore(requester, themeId, lastNewsId) {
        requester.send(qsTr(api.themeMore).arg(themeId.toString()).arg(lastNewsId.toString()));
    }
    // 热门文章
    function apiNewsHot(requester) {
        requester.send(api.newsHot);
    }
    // 赞助
    function apiSponsor(requester) {
        requester.setHeaders({
            "appinfo": getHardwareInfo()
        });
    
        requester.send(api.sponsor);
    }
    // 开发者消息
    function apiMessage(requester) {
        requester.setHeaders({
            "appinfo": getHardwareInfo()
        });
        
        requester.send(api.message);
    }
    // ============ api end ============
    function getHardwareInfo() {
        return JSON.stringify({
            version: version,
            modelName: hardwareInfo.modelName,
            modelNumber: hardwareInfo.modelNumber,
            hardwareId: hardwareInfo.hardwareId,
            pin: hardwareInfo.pin
        });
    }
    
    function httpGetAsync(theUrl, callback) {
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function() { 
            if(xmlHttp.readyState == 4) {
                if(xmlHttp.status == 200) {
                    callback(true, xmlHttp.responseText);
                }else {
                    callback(false, xmlHttp.statusText);
                }
            }
        }
        xmlHttp.open("GET", theUrl, true); // true for asynchronous 
        xmlHttp.send(null);
    }
}
