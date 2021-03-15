module BaseHelper

  def notice_message
    content_tag(:div, infomation_icon + flash[:notice], :class => "notice-message") if !flash[:notice].blank?
  end
  
  def warning_message(mes)
    warning_button_s + content_tag(:span,mes,:class=>"warning-message")
  end
    
  def icon_button_s(label, icon_type, link=nil, options={})
    options[:class] = (options[:class] || "") + " icon-button-s"
    if link.blank?
      options[:alt]=label
      image_tag "icons/16/#{icon_type}.png", options
    else
      link_to image_tag("icons/16/#{icon_type}.png", :alt=>label), link, options
    end
  end

  def lock_button(link)
    options = {}
    options[:class] = (options[:class] || "") + " icon-button-s"
    options[:width] = '16px'
    if link.blank?
      options[:alt]="password"
      image_tag "icons/lock.png", options
    else
      link_to image_tag("icons/lock.png", :alt=>label), link, options
    end
  end
  
  def info_button_s(link=nil)
    icon_button_s("","infomation")
  end
  
  def warning_button_s(link=nil)
    icon_button_s("注意！","alert")
  end
  
  def add_button_s(link, options={})
    icon_button_s("追加","add", link, options)
  end
  def edit_button_s(link, options={})
    icon_button_s("編集","list-edit", link, options)
  end
  def detail_button_s(link, options={})
    icon_button_s("詳細","document-go", link, options)
  end
  
  def zoomin_button_s(link, options={})
    icon_button_s("拡大","zoom-in", link, options)
  end
  
  def delete_button_s(link, options={})
    icon_button_s("削除","delete", link, options)
  end
  
  
  
  
  
  def infomation_icon
    icon_button(nil,"infomation")
  end
  def add_button(link,options={})
    icon_button("追加","add", link,options)
  end
  def edit_button(link,options={})
    icon_button("編集","document-edit", link,options)
  end
  def search_button(link,options={})
    icon_button("検索","search", link,options)
  end
  def return_button(link,options={})
    icon_button("戻る","left2", link,options)
  end
  def cancel_button(link,options={})
    icon_button("中止","cancel", link,options)
  end
  def delete_button(link,options={})
    icon_button("削除","delete", link,options)
  end
  
  def icon_button(label,icon_type,link=nil,options={})
    options[:class] = (options[:class] || "") + " icon-button"
    ret  = image_tag("icons/32/#{icon_type}.png", :alt=>label)
    logger.debug("icon_button : (#{ret})")
    ret += tag("br") + "[#{label}]" if !label.blank?
    #logger.debug("icon_button : (#{ret})")
    if !link.blank?
      #logger.debug("icon_button : ret(#{ret})")
      #logger.debug("icon_button : link(#{link.to_s})")
      #logger.debug("icon_button : options(#{options.to_s})")
      link_to ret, link, options
    else
      return ret
    end
  end
  
  
  
  
  def view_button(size=32)
    image_tag("icons/#{size}/document-go.png", :alt=>"詳細")
  end
  
  def list_button(size=32)
    image_tag("icons/#{size}/list.png", :alt=>"リスト")
  end
  
  
end