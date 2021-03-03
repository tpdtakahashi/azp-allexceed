#!/bin/sh

wget http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip
unzip ken_all.zip
iconv -f SJIS -t UTF8 KEN_ALL.CSV | sed -e 's/\r//g' -e 's/"//g' -e 's/以下に掲載がない場合//g' | awk 'BEGIN{FS=",";OFS=",";rtn=0}{if(rtn==0){print($3, substr($1,1,2), $7, $8, $9)}} /（/{rtn=1} /）/{rtn=0}' | sed  -e 's/（.*$//g' -e 's/[０１２３４５６７８９]\+.*[、〜].*//g' | sort | uniq | tee zip_code_seed.csv | awk 'BEGIN{FS=",";OFS=","}{print $2,$3}' | sort | uniq > prefecture_name_seed.csv
