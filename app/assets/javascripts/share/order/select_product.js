var OrderProductTable = function(params){
    
    this.params = params || {};
    
    this.popup_id = this.params["popup_id"] || "popupSelectProducts";
    
    this.table_block_class = this.params["table_block_class"] || "order-products-table";
    
    this.products_table_class = this.params["products_table_class"] || "products-table";
    
    this.selectMode = this.params["selectMode"] || "multi";
    
    this.TransportationMode = this.params["TransportationMode"] || "auto";
    this.CODFeeMode = this.params["CODFeeMode"] || "auto";
    
    this.TransportationThreshold = this.params["TransportationThreshold"] || 6000;
    this.AutoTransportationValue = (this.params["AutoTransportationValue"] == null ? 700 : this.params["AutoTransportationValue"]);
    
    this.reset();
}

OrderProductTable.prototype = {
    reset:function(){
        this.popup_widget = $("#" + this.popup_id);
        this.table_block = $("table." + this.table_block_class);
        
        this.products_table = $("table." + this.products_table_class);
        
        this.products_field = this.table_block.find("tbody.product-rows");
        this.prices_field = this.table_block.find("tbody.order-prices");
        
        var inst = this;
        var addbutton = this.products_table.find(".add-action-cell a");
        addbutton.on("click",function(){
            var cell = $(this).parent();
            var row = cell.parent();
            inst.add_product_row(row.clone(false));
            if( inst.selectMode == 'single' )
                inst.popup_widget.popup("close");
        });
        
        var rows = this.products_field.find("tr.product-row");
        this.set_rows_event(rows);
        
        this.prices_field.find(".order-transportation").on("change",function(){
            inst.sum_price();
        });
        this.prices_field.find(".order-cod-fee").on("change",function(){
            inst.sum_price();
        });
        $("#include_regular_order").on("change",function(){
            inst.sum_price();
            if( $("#include_regular_order").prop("checked") ){
              $("#order_delivery_on").val("");
              $("#order_delivery_on").attr('disabled',true);
              $("#order_delivery_time").val(0);
              $("#order_delivery_time").attr('disabled',true);
            }else{
              $("#order_delivery_on").removeAttr('disabled');
              $("#order_delivery_time").removeAttr('disabled');
            }
        });
    },
    add_product_row: function(row){
        var add_product_id = this.row_product_id(row);
        if( this.has_product(add_product_id, this.products_field.find("tr")) ){
            alert("すでに追加されている商品です");
            return;
        }
        row.find(".add-action-cell").remove();
        row.prepend('<td class="dalete-action-cell"><a href="#" class="delete-button">削除</a></td>');
        row.append('<td class="product-sum-price" align="right"></td>');
        this.set_rows_event(row);
        this.products_field.append(row);
        this.calc_row_price(row);
        this.sum_price();
    },
    set_rows_event: function(rows){
        var inst = this;
        var del_btn = rows.find("a.delete-button");
        del_btn.on("click",function(){
            var cell = $(this).parent();
            var row = cell.parent();
            row.remove();
            inst.sum_price();
        });
        rows.find("input.order-price").on("change",function(){
            var td = $(this).parent();
            var tr = td.parent();
            inst.calc_row_price(tr);
            inst.sum_price();
        });
        rows.find("input.order-number").on("change",function(){
            var td = $(this).parent();
            var tr = td.parent();
            inst.calc_row_price(tr);
            inst.sum_price();
        });
    },
    calc_row_price: function(row){
        var number = row.find("input.order-number").val();
        var price = row.find("input.order-price").val();
        var total = number * price;
        row.find(".product-sum-price").html(total);
        return total;
    },
    
    sum_price: function(){
        var sum = 0;
        var rows = this.products_field.find("tr");
        var regular_include = $("#include_regular_order").prop("checked");
        var inst = this;
        rows.each(function(){
            sum = sum + inst.calc_row_price($(this));
        });
        this.prices_field.find(".order-sum-price").val(sum);
        
        var transportation_field = this.prices_field.find(".order-transportation");
        var cod_fee_field = this.prices_field.find(".order-cod-fee");
        
        
        //if(sum < 6000 && !regular_include){
        if(sum < this.TransportationThreshold){
          var default_t = this.prices_field.find("#default-transportation").val();
          if(this.TransportationMode == "auto")transportation_field.val(default_t);
          var default_c = this.prices_field.find("#default-cod-fee").val();
          if(this.CODFeeMode == "auto") cod_fee_field.val(default_c);
        }else{
          if(this.TransportationMode == "auto")transportation_field.val(this.AutoTransportationValue);
          if(this.CODFeeMode == "auto")cod_fee_field.val(0);
        }
        
        if( regular_include ){
          if(this.TransportationMode == "auto")transportation_field.val(0);
        }
        
        var transportation = transportation_field.val() || 0;
        var cod_fee = this.prices_field.find(".order-cod-fee").val() || 0;
        var total = sum;
//        if(sum < 6000) total = total + Number(transportation);
//        if(sum < 6000) total = total + Number(cod_fee);
        total = total + Number(transportation);
        total = total + Number(cod_fee);
        this.prices_field.find(".order-total-price").val(total);
    },
    row_product_id: function(row){
        return row.find("input.product-id").val();
    },
    has_product:function(product_id,rows){
        var has = false;
        var inst = this;
        rows.each(function(){
            if( inst.row_product_id($(this)) == product_id) has = true;
        });
        return has;
    }
};
