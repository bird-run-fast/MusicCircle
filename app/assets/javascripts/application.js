// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(document).on('turbolinks:load',function(){
// イベント検出ゾーン

  // マイページのオプションの表示切替部分(enduser-showアクション)
  $(".show-postIndex-btn").on("click", function(){
    $("#enduser-show-chatIndex").addClass("nonactive")
    $("#enduser-show-postIndex").removeClass("nonactive")
  });

  $(".show-chatIndex-btn").on("click", function(){
    $("#enduser-show-postIndex").addClass("nonactive")
    $("#enduser-show-chatIndex").removeClass("nonactive")
  });

  // マイページのオプションの表示切替部分(enduser-showアクション)ここまで


  // タグ機能(post-new,editアクション)
  // タグフォーム横の+ボタンが押されたらイベント検出
  $(".tag-btn").on("click", function(){
    var tagInput = document.getElementById("post-new-tagform").value;
    var tagLen = tagInput.length;
    // 追加したいタグの文字数が1~10文字以内かを確認し、範囲外ならエラーを出す
    if(tagLen >= 1 && tagLen <= 10){
      // +ボタンが押されたら、追加したタグをviewに一覧表示し、入力フォーム内の値は空にする
      $(".tag-list").append(`<span class="tag-list-items tagDelete-btn btn" id="tagList-${tagInput}">${tagInput}</span>`);
      $("#post-new-tagform").val("");
      // 文字数制限のnoticeが出てたら隠す
      $(".tag-notice").addClass("tag-notice-hide");
      // フォーム用の値をtag-formクラスのdivにいれる
      $(".tag-form").append(`<input type="text" value="${tagInput}" name="tags[]" id="tagForm-${tagInput}">`);
    }else{
      $(".tag-notice").removeClass("tag-notice-hide");
    }
  });

  $(".tag-list").on("click",".tagDelete-btn", function(){
    var id =  $(this).attr("id");
    var value = id.split("-")[1];
    $("#tagList-" + value).remove();
    $("#tagForm-" + value).remove();
  });
  // タグ機能(post-new,editアクション)

// 関数設定ゾーン

});
