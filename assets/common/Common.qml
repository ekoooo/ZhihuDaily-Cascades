import bb.cascades 1.4

QtObject {
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
}
