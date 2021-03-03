# -*- encoding: utf-8 -*-
require "rexml/document" 
require 'nokogiri'
require "RMagick"

class Tpd::PrintTemplate
  
  @file_data = ""
  @xml
  
  def initialize(name,print_options={})
    print_options = {} if print_options.nil?
    @options = {
	  :tmp_dir => "tmp/SVGPrint"
	}.merge(print_options)
	
    @file_data = ""
    @file_data = self.class.load(name)
  end
  
  def data
    return @file_data
  end
  
  def create_temp_file_name
    timecode = DateTime.now.strftime("temp%Y%m%d%H%M%s")
    randcode = self.class.random_string
    return timecode + randcode
  end
  
  def to_pdf
    filename = create_temp_file_name
    
	# 一時ファイル保存用ディレクトリ名取得
	dir = @options[:tmp_dir]
	
	# ディレクトリ作成（無ければ）
	FileUtils.mkdir_p(dir)
    
	# svg 一時ファイル保存
    svgtmpfile = "tmp/#{filename}.svg"
    fp = open(svgtmpfile ,"w")
    fp.write(@file_data)
    fp.close
    
	# inkscape で PDF ファイル生成
    pdftmpfile = "tmp/#{filename}.pdf"
    result = system("inkscape -A " + pdftmpfile + " " + svgtmpfile)
    
	# PDF ファイル読込
    fp = open(pdftmpfile, "rb")
    pdf = fp.read
    fp.close
    
	# 一時ファイル削除
    File.unlink(svgtmpfile,pdftmpfile)
    
    return pdf
  end
  
  def to_svg_pdf
    # ユニークな一時ファイル名生成
    filename = create_temp_file_name
    
	# 一時ファイル保存用ディレクトリ名取得
	dir = @options[:tmp_dir]
	
	# ディレクトリ作成（無ければ）
	FileUtils.mkdir_p(dir)
    
	# svg 一時ファイル保存
    svgtmpfile = "#{dir}/#{filename}.svg"
    fp = open(svgtmpfile ,"w")
    fp.write(@xml.to_xml)
    fp.close
    
	# inkscape で PDF ファイル生成
    pdftmpfile = "#{dir}/#{filename}.pdf"
    result = system("inkscape -A " + pdftmpfile + " " + svgtmpfile)
    
	# PDF ファイル読込
    fp = open(pdftmpfile, "rb")
    pdf = fp.read
    fp.close
    
	# 一時ファイル削除
    File.unlink(svgtmpfile)
    File.unlink(pdftmpfile)
    
    return pdf
  end
  
  def gsub!(p,r)
    @file_data.gsub!(p,r)
  end
  
  def xml_analize()
    #@xml = REXML::Document.new(@file_data)
    @xml = Nokogiri::XML(@file_data)
  end
  
  def put(p,r)
    @file_data.gsub!(/\@\{#{p}\}/,r)
  end
  
  def get_xml_elem(p)
    elems = @xml.css("##{p}")
    return nil if elems.blank? or elems.empty?
    elems.first
  end
  
  
  
  def put_text(p,r)
    elem = get_xml_elem(p)
    return if elem.blank?
    elem.content = r
  end
  
  def put_text_area(p,r)
    prnt = get_xml_elem(p)
    return if prnt.blank?
    prnt.xpath("svg:flowPara").each {|c| c.remove}
    
    r.split("\n").each_with_index do |l,i|
      elem = Nokogiri::XML::Node.new "svg:flowPara", @xml
      elem.set_attribute("id","#{p}_#{i}")
      elem.content = l
      prnt.add_child(elem)
    end
  end

  def put_img(p,r)
    elem = get_xml_elem(p)
    return if elem.blank?
    elem.set_attribute("xlink:href",r)
  end
  
  def set_img(p,img)
    max_width, max_height = get_img_size(p)
    wid = img.columns
    high = img.rows
    
    if(wid < max_width and high < max_height)
      set_img_width(p, wid)
      set_img_height(p, high)
    else
      per_w = max_width.to_f / wid.to_f
      per_h = max_height.to_f / high.to_f
      
      if per_w < per_h
        new_width = wid * per_w
        new_height = high * per_w
      else
        new_width = wid * per_h
        new_height = high * per_h
      end
      
      set_img_width(p, new_width.to_i)
      set_img_height(p, new_height.to_i)
    end
    
    put_img(p, "data:image/#{img.format.downcase};base64,"+Base64.encode64(img.to_blob))
  end
  
  def get_img_size(p)
    img = get_xml_elem(p)
    return if img.blank?
    wid = img.attributes["width"].value.to_i
    high = img.attributes["height"].value.to_i
    return wid,high
  end

  def set_img_width(p,wid)
    img = get_xml_elem(p)
    return if img.blank?
    img.attributes["width"].value = wid.to_s
  end
  def set_img_height(p,high)
    img = get_xml_elem(p)
    return if img.blank?
    img.set_attribute("height",high.to_s)
  end
  
  def del_tag(name)
    elem = get_xml_elem(name)
    return if elem.blank?
    elem.remove
  end
  
  
  def put_field(gp,items={})
  end
  
  def group_increase(p,newname)
    g = get_xml_elem(p)
    c = g.clone
    c.set_attribute("id",newname.to_s)
    g.parent.add_child(c)
    
    c = get_xml_elem(newname)
    
    cnt = c.children.length
    total = 0
    descendants = c.children
    d = descendants.shift
    while !d.nil?
      d.set_attribute("id","#{newname.to_s}-#{d["id"]}")
      descendants = descendants + d.children
      d = descendants.shift
      total = total + 1
    end
    
    
    return [cnt,total]
  end
  
  def group_move(p,x,y)
    g = get_xml_elem(p)
    g.set_attribute("transform","translate(#{x},#{y})")
  end
  
  
  
  def self.load(name)
    fp=open("template/#{name}.svg")
    svg = fp.read
    fp.close
    return svg
  end
  
  def convert()
  end
  
  def temp_save
  end
  
  
  def self.cat_pdf(pdfs)
    timecode = DateTime.now.strftime("temp%Y%m%d%H%M%s")
    randcode = random_string
    filename = timecode + randcode
    tmpfiles = []
    pdfs.each_with_index do |pdf,n|
      tmpfile = "tmp/#{filename + "_" + n.to_s.rjust(2,'0')}.pdf"
      fp = open(tmpfile ,"wb")
      fp.write(pdf)
      fp.close
      tmpfiles << tmpfile
    end
    pdftmpfile = "tmp/#{filename}_join.pdf"
    result = system("pdftk " + tmpfiles.join(" ") + " output " + pdftmpfile)
    
    fp = open(pdftmpfile)
    pdf = fp.read
    fp.close
    
    tmpfiles.each {|file| File.unlink(file)}
    File.unlink(pdftmpfile)
    
    return pdf
  end
  
protected  
  def self.random_string(length = 8)
    source = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    t = Time.now
    srand(t.to_i ^ t.usec ^ Process.pid)
    str = ""
    length.times{ str += source[rand(source.size)].to_s }
    return str
  end  
end
