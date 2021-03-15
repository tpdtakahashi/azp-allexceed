$(function(){
  $(".open-cart-product-number-edit-form").click(function(){
    var prnt = $(this).parent();
    var editor = prnt.children(".cart-product-number-edit-form");
    editor.show();
    $(this).hide();
    return false;
  });
});


function open_cart_product_number_edit_form(btn) {
  var prnt = $(btn).parent();
  var editor = prnt.children(".cart-product-number-edit-form");
  editor.show();
  $(btn).hide();
  return false;
}
