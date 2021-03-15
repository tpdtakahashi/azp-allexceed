class Estate::Madori < Tpd::UploadFile::Image

    belongs_to :estate, class_name: '::Estate::Common'
end