class Admins::ChartsController < ApplicationController
  def index
    # 期間別の会員者数、投稿数の集計データー
    # gem"chartKick"を使用する場合、二重配列のデータをviewに渡してあげると、グラフの形で表示できる。eD,pD,eM
    # eD,pDはenduserとpostをcreated_atカラムで日ごと集計したもの. [["2020-08-17", 0], ["2020-08-18", 0], ...]　みたいな形になってる
    eD = Enduser.all.group_by_day(:created_at, format: "%b/%d").count.to_a
    pD = Post.all.group_by_day(:created_at, format: "%b/%d").count.to_a
    # eM,pMはenduserとpostをcreated_atカラムで月ごと集計したもの. [["2020-08-01", 0], ["2020-08-01", 0], ...]　みたいな形になってる
    eM = Enduser.all.group_by_month(:created_at, format: "%Y/%b").count.to_a
    pM = Post.all.group_by_month(:created_at, format: "%Y/%b").count.to_a

    # 一週間の会員登録者数、投稿数
    eD.count >= 7 ? @endusersWeek = eD.slice(-7..-1) : "期間が短いためまだ集計が作られません"
    pD.count >= 7 ? @postsWeek = pD.slice(-7..-1) : "期間が短いためまだ集計が作られません"

    # 一ヶ月の会員登録者数、投稿数
    eD.count >= 30 ? @endusersMonth = eD.slice(-30..-1) : "期間が短いためまだ集計が作られません"
    pD.count >= 30 ? @postsMonth = pD.slice(-30..-1) : "期間が短いためまだ集計が作られません"

    # 一年の会員登録者数、投稿数
    eM.count >= 12 ? @endusersYear = eM.slice(-12..-1) : "期間が短いためまだ集計が作られません"
    pM.count >= 12 ? @postsYear = pM.slice(-12..-1) : "期間が短いためまだ集計が作られません"
    # 期間別の会員者数、投稿数の集計データーここまで

    # 注意対象のユーザー一覧部分

    # すでにバッチ処理によりユーザースコアは採点されている。採点の詳細については batches/scoreアクションで確認する。
    # 今回はユーザースコアが -0.5を下回っているユーザーを一覧表示する
    @attentionTargetUsers = Enduser.where(score: -1.0..-0.5, is_deleted: false)

    # 注意対象のユーザー一覧部分ここまで
  end
end
