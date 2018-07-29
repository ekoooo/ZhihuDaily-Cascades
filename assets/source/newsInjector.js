$(function() {
    // 图片 invoke
    setInvokeImage();
    // 链接 invoke
    setInvokeLink();
});

function setInvokeImage() {
    $('.content-wrap img').on('click', function(e) {
        navigator.cascades.postMessage(JSON.stringify({
            event: 'invokeImage',
            url: e.currentTarget.src
        }));
    });
}

function setInvokeLink() {
    $('.content-wrap a').on('click', function(e) {
        var url = e.currentTarget.href;

        if(url.indexOf('http') === 0) {
            e.preventDefault();
            
            navigator.cascades.postMessage(JSON.stringify({
                event: 'invokeLink',
                url: url
            }));
        }
    });
}

/**
 * 切换夜间模式
 * @param isNight
 */
function setNightMode(isNight) {
    isNight ? $('#body').addClass('night') : $('#body').removeClass('night');
}

/**
 * 大字体模式
 * @param isLarge
 */
function setLargeFont(isLarge) {
    isNight ? $('#body').addClass('large') : $('#body').removeClass('large');
}