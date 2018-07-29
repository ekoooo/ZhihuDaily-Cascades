/**
 * 知乎日报 API
 */
var Api = {
    // 最新消息
    "newsLatest": "http://news-at.zhihu.com/api/4/news/latest",
    // 热门消息
    "newsHot": "http://news-at.zhihu.com/api/4/news/hot",
    // 过往消息, e.g. http://news-at.zhihu.com/api/4/news/before/20131119
    "newsBefore": "http://news-at.zhihu.com/api/4/news/before/%1",
    // 消息内容, e.g. http://news-at.zhihu.com/api/4/news/#{id}
    "news": "http://news-at.zhihu.com/api/4/news/%1",
    // 主题日报列表
    "themes": "http://news-at.zhihu.com/api/4/themes",
    // 主题日报内容, e.g. http://news-at.zhihu.com/api/4/theme/#{id}
    "theme": "http://news-at.zhihu.com/api/4/theme/%1",
    // 主题日报列表加载更多 1. themeId 2.newsId
    "themeMore": "http://news-at.zhihu.com/api/4/theme/%1/before/%2",
    // 栏目总览
    "sections": "http://news-at.zhihu.com/api/4/sections",
    // 栏目具体消息查看, e.g. http://news-at.zhihu.com/api/3/section/#{id}
    "section": "http://news-at.zhihu.com/api/4/section/%1",
    //栏目列表加载更多 1. sectionId 2.timestamp
    "sectionMore": "http://news-at.zhihu.com/api/4/section/%1/before/%2",
    // 新闻额外信息, e.g. http://news-at.zhihu.com/api/4/story-extra/#{id}
    "storyExtra": "http://news-at.zhihu.com/api/7/story-extra/%1",
    // 新闻的推荐者, e.g. http://news-at.zhihu.com/api/4/story/#{id}/recommenders
    "storyRecommenders": "http://news-at.zhihu.com/api/4/story/%1/recommenders",
    // 新闻对应长评论查看, e.g. http://news-at.zhihu.com/api/4/story/#{id}/long-comments
    "storyLongComments": "http://news-at.zhihu.com/api/4/story/%1/long-comments",
    "storyNextLongComments": "http://news-at.zhihu.com/api/4/story/%1/long-comments/before/%2",
    // 新闻对应短评论查看, e.g. http://news-at.zhihu.com/api/4/story/#{id}/short-comments
    "storyShortComments": "http://news-at.zhihu.com/api/4/story/%1/short-comments",
    "storyNextShortComments": "http://news-at.zhihu.com/api/4/story/%1/short-comments/before/%2",
    /*
     * 长评论翻页:
     * http://news-at.zhihu.com/api/4/story/7809160/long-comments
     * http://news-at.zhihu.com/api/4/story/7809160/long-comments/before/26092304
     * 短评论翻页:
     * http://news-at.zhihu.com/api/4/story/7809160/short-comments
     * http://news-at.zhihu.com/api/4/story/7809160/short-comments/before/26354994
     */
    // 赞助
    "sponsor": "https://ekoooo.github.io/ZhihuDaily-Cascades/sponsor.json",
};