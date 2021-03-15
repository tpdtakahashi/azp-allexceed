function dispLoading(msg){
    // 画面表示メッセージ
    var dispMsg = "";
 
    // 引数が空の場合は画像のみ
    if( msg != "" ){
        dispMsg = "<div class='loadingMsg'>" + msg + "</div>";
    }
    // ローディング画像が表示されていない場合のみ表示
    if($("#loading").length <= 0) 
    {
        $("body").append("<div id='loading'>" + dispMsg + "</div>");
    } 
}
// Loadingイメージ削除関数
function removeLoading(){
 $("#loading").remove();
}
