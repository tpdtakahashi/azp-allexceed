require "csv"

def import_zip
count = 0

Tpd::Address::Zip.delete_all
CSV.foreach('db/zipcode/zip_code_seed.csv') do |row|
  record = {
    :code     => row[0],
    :prefecture_id => row[1].to_i,
    :prefecture_name => row[2],
    :city_name       => row[3],
    :area_name       => row[4],
  }
  Tpd::Address::Zip.create!(record)
  count = count + 1
  if count % 500 == 0
    p count.to_s
  end  
end
  return ""
end

import_zip