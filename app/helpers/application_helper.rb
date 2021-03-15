module ApplicationHelper
    def cut_off(text, len)
      if text != nil
        if RUBY_VERSION <= '1.8.7'
          text_length = text.jlength
        else
          text_length = text.length
        end
        if text_length < len
          text
        else
          text.scan(/^.{#{len}}/m)[0] + "…"
        end
      else
        ''
      end
    end
    def number_format(num)
      return (num.to_s =~ /[-+]?\d{4,}/) ? (num.to_s.reverse.gsub(/\G((?:\d+\.)?\d{3})(?=\d)/, '\1,').reverse) : num.to_s
    end

    # 
    def admin_estate_record_path(common)
      if common.land?
        return admin_estate_land_path(common.land)
      elsif common.house?
        return admin_estate_house_path(common.house)
      else
      end
    end
end
