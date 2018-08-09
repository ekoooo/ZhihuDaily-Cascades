$(function() {
    // 图片 invoke
    setInvokeImage();
    // 链接 invoke
    setInvokeLink();
    // 初始化无图模式
    initFastImageMode();
});

function endWith(str, endStr) {
    var d = str.length - endStr.length;
    return (d >= 0 && str.lastIndexOf(endStr) === d);
}

function initFastImageMode() {
    var body = $('body');
    var imgs = $('.content-wrap img');
    var len = imgs.length, item, _item, src;
    
    var isFastMode = body.hasClass('fast_mode');
    var isAutoLoadGif = body.hasClass('auto_load_gif');
    
    for(var i = 0; i < len; i++) {
        item = imgs[i];
        item_ = $(item);
        src = item.src;
        
        // ‘无图模式’和‘不自动加载 gif’
        if(isFastMode || (!isAutoLoadGif && endWith(src, '.gif'))) {
            item_.addClass('bb10_default_pic');
            item_.attr('data-src', src);
            item_.attr('src', 'local:///assets/images/default_pic_content_image_download_dark.png');
        }
    }
}

function setInvokeImage() {
    $('.content-wrap img').on('click', function(e) {
        var ct = $(e.currentTarget);
        if(ct.hasClass('bb10_default_pic')) {
            ct.attr('src', ct.attr('data-src'));
            ct.removeClass('bb10_default_pic');
            
            e.preventDefault(); // 广告图片，禁止跳转
            e.stopPropagation();
            return;
        }
        
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