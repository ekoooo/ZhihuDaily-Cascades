$(function() {
    // 图片 invoke
    setInvokeImage();
});

function setInvokeImage() {
    $('.content-wrap img').on('click', function(e) {
        navigator.cascades.postMessage(JSON.stringify({
            event: 'invokeImage',
            url: e.currentTarget.src
        }));
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