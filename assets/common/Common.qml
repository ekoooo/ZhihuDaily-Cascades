import bb.cascades 1.4

QtObject {
    // 设置 key
    property variant settingsKey: {
        // 主题
        "theme": "theme",
        // 文章大字体
        "newsLargeFont": "newsLargeFont",
        // 文章护眼模式
        "newsEyeProtectionModel":"newsEyeProtectionModel"
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
}
