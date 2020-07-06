module ApplicationHelper
  def flash_message(message, klass)
    content_tag(:div, class: "alert alert-#{klass}") do
      concat content_tag(:button, 'x', class: 'close', data: {dismiss: 'alert'})
      concat raw(message)
    end
  end
  
  def default_meta_tags
    {
      site: 'アフターキャンパス',
      title: 'アフターキャンパス',
      reverse: true,
      charset: 'utf-8',
      description: '「飲みに行こう！」と駅に集まり、「どこ行く？」「いつものとこで良くない？」「安いところ?」結局いつもと同じ居酒屋...そんな悩みを解決する予算3000円で楽しめる大学生専用飲み会サイト！',
      keywords: '居酒屋, 居酒屋 安い, 大学生 オススメ 居酒屋, 飲み放題 居酒屋, 渋谷 居酒屋, 新宿, 大学生 バー, 飲み屋 安い',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('toplogo.png') },
        { href: image_url('toplogo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
      og: {
        site_name: :site, # もしくは site_name: :site
        title: :title, # もしくは title: :title
        description: :description, # もしくは description: :description
        type: 'website',
        url: request.original_url,
        image: image_url('toplogo.png'),
        locale: 'ja_JP',
      },
      #twitter: {
        #card: 'summary',
        #site: '@ツイッターのアカウント名',
      #}
    }
  end
end
