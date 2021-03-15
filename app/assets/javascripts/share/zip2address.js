var AddressSearch = function(params){
    
    this.params = params || {};
    this.base_field_id = this.params["base_field_id"] || "address-field";
    
    this.zip_to_address_button_class = this.params["zip_to_address_button_class"] || "zip-to-address-button";
    
    this.address_zipcode_field_class = this.params["address_zipcode_field_class"] || "address-zipcode-field";
    this.address_pref_field_class = this.params["address_pref_field_class"] || "address-pref-field";
    this.address_city_field_class = this.params["address_city_field_class"] || "address-city-field";
    this.address_area_field_class = this.params["address_area_field_class"] || "address-area-field";
    this.address_else_field_class = this.params["address_else_field_class"] || "address-else-field";
    
    this.select_address_dialog = {};
    this.select_address_dialog_params = this.params["select_address_dialog"] || {};
    this.select_address_dialog_id = this.select_address_dialog_params["id"] || "select-address-dialog";
    this.select_address_dialog_address_field_class = this.select_address_dialog_params["address_field_class"] || "select-address-area";
    
    this.zip_to_address_url = '/zipcode/';
    
    this.update();
    
}

AddressSearch.prototype = {
    update: function(){
        this.base_field = $("#" + this.base_field_id);
        this.zip_to_address_button = this.base_field.find("." + this.zip_to_address_button_class);
        
        this.address_zipcode_field = this.base_field.find("." + this.address_zipcode_field_class);
        this.address_pref_field = this.base_field.find("." + this.address_pref_field_class);
        this.address_city_field = this.base_field.find("." + this.address_city_field_class);
        this.address_area_field = this.base_field.find("." + this.address_area_field_class);
        this.address_else_field = this.base_field.find("." + this.address_else_field_class);
        
        
        this.select_address_dialog = $("#" + this.select_address_dialog_id);
        this.select_address_dialog_address_field = this.select_address_dialog.find("." + this.select_address_dialog_address_field_class);
        
        var inst = this;
        this.zip_to_address_button.on("click",function(){
            inst.zip2address();
        });
    },
    zip2address: function(){
        var zipcode = this.address_zipcode_field.val();
        
        /*$.mobile.loading( "show", {
            text: "Loading...",
            textVisible: true,
        });*/

        dispLoading("loading...");
        
        var inst = this;
        $.ajax('/zipcode/' + zipcode, {
            method: 'GET',
            contentType: false,
            processData: false,
            dataType: 'json',
            error: function(xhr,status, error) {
              // $.mobile.loading("hide");
               //removeLoading();
              console.log('アップデートに失敗しました');
              console.log(error);
              alert('Error! ' + status + ' ' + error);
            },
            success: function(response) {
               //$.mobile.loading("hide");
              console.log('アップロードに成功しました');
              console.log(response);
              if( response.length < 1 ){
                  alert("該当する住所が見つかりませんでした");
              }else if( response.length > 1 ){
                  inst.select_address(response);
              }else{
                  
                  inst.set_address(response[0].prefecture_name, response[0].city_name, response[0].area_name);
              }
            },
            complete: function(){
               //$.mobile.loading("hide");
               removeLoading();
            }
        });        
    },
    select_address: function(addresses){
        this.select_address_dialog_address_field.html("");
        for(var i=0;i<addresses.length;i++){
            var address_params = addresses[i];
            var address = address_params.prefecture_name + address_params.city_name + address_params.area_name;
            var address_params = 'data-address-pref="' + address_params.prefecture_name + '" ';
            address_params = ' data-address-city="' + address_params.city_name + '" ';
            address_params = ' data-address-area="' + address_params.area_name + '" ';
            this.select_address_dialog_address_field.append('<a href="#" class="select-address-item" ' + address_params + '>' + address + '</a>');
            
        }
        
        this.select_address_dialog_address_field.find("a.select-address-item").on("click",function(){
            var pref = $(this).attr("data-address-pref");
            var city = $(this).attr("data-address-city");
            var area = $(this).attr("data-address-area");
            
        });
        
        this.select_address_dialog.popup("open");
    },
    set_address: function(pref,city,area){
        this.address_pref_field.val(pref);
        this.address_city_field.val(city);
        this.address_area_field.val(area);
        this.address_else_field.val("");
    }
};


function zip2address(btn) {
    var frm = $(btn);
    var frm_id = frm.attr("id");
    var parent = frm.parent(".address_field");
    var address_field_id = parent.attr("id");
    var formData = new FormData(frm[0]);
    
    var zipcode = $("#" + address_field_id + " .zip-code-field").val();
    
    $.ajax('/zipcode/' + zipcode, {
        method: 'GET',
        contentType: false,
        processData: false,
        dataType: 'json',
        error: function(xhr,status, error) {
          console.log('アップデートに失敗しました');
          console.log(error);
          alert('Error! ' + status + ' ' + error);
        },
        success: function(response) {
          console.log('アップロードに成功しました');
          console.log(response);
          if( response.length < 1 ){
            $( "#progress" ).dialog( "close" );
            alert("該当する住所が見つかりませんでした");
          }else if( response.length > 1 ){
            select_address_dialog(address_field_id, response);
          }else{
            set_address(address_field_id,response[0].prefecture_name, response[0].city_name, response[0].area_name);
          }
        },
        complete: function(){
           $( "#progress" ).dialog( "close" );
        }
    });
    return false;
}


function select_address_dialog(field,addresses){
  $("#select-address-area").html("");
  for(var i=0;i<addresses.length;i++){
    var address_params = addresses[i];
    var address = address_params.prefecture_name + address_params.city_name + address_params.area_name;
    var args = "'" + field + "','" + address_params.prefecture_name + "','" + address_params.city_name + "','" + address_params.area_name + "'";
    $("#select-address-area").append('<a href="#" onclick="set_address(' + args + ');return false;">' + address + '</a><br />');
  }
  $( "#select-address-dialog" ).dialog( "open" );
}

function set_address(field,pref,city,area){
  $("#" + field + " .address-prefecture-field").val(pref);
  $("#" + field + " .address-city-field").val(city);
  $("#" + field + " .address-area-field").val(area);
  $( "#select-address-dialog" ).dialog( "close" );
}