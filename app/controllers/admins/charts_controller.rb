class Admins::ChartsController < ApplicationController
  def index
    # 期間別の会員者数、投稿数の集計データー
    # gem"chartKick"を使用する場合、二重配列のデータをviewに渡してあげると、グラフの形で表示できる。eD,pD,eM
    # eD,pDはenduserとpostをcreated_atカラムで日ごと集計したもの. [["2020-08-17", 0], ["2020-08-18", 0], ...]　みたいな形になってる
    eD = Enduser.all.group_by_day(:created_at, format: "%b/%d").count.to_h
    pD = Post.all.group_by_day(:created_at, format: "%b/%d").count.to_h
    # eM,pMはenduserとpostをcreated_atカラムで月ごと集計したもの. [["2020-08-01", 0], ["2020-08-01", 0], ...]　みたいな形になってる
    eM = Enduser.all.group_by_month(:created_at, format: "%Y/%b").count.to_h
    pM = Post.all.group_by_month(:created_at, format: "%Y/%b").count.to_h

    # 一週間の会員登録者数、投稿数
    @endusersWeek = []
    @postsWeek = []
    (1..7).each do |i|
      @endusersWeek << [i.days.ago.strftime('%b/%d'), eD.fetch("#{i.days.ago.strftime('%b/%d')}", 0)]
      @postsWeek << [i.days.ago.strftime('%b/%d'), pD.fetch("#{i.days.ago.strftime('%b/%d')}", 0)]
    end

    # 一ヶ月の会員登録者数、投稿数
    @endusersMonth = []
    @postsMonth = []
    (1..30).each do |i|
      @endusersMonth << [i.days.ago.strftime('%b/%d'), eD.fetch("#{i.days.ago.strftime('%b/%d')}", 0)]
      @postsMonth << [i.days.ago.strftime('%b/%d'), pD.fetch("#{i.days.ago.strftime('%b/%d')}", 0)]
    end

    # 一年の会員登録者数、投稿数
    @endusersYear = [[Date.today.beginning_of_month.strftime('%Y/%b'), eM.fetch("#{Date.today.beginning_of_month.strftime('%Y/%b')}", 0)]]
    @postsYear = [[Date.today.beginning_of_month.strftime('%Y/%b'), pM.fetch("#{Date.today.beginning_of_month.strftime('%Y/%b')}", 0)]]
    (1..11).each do |i|
      @endusersYear << [i.months.ago.beginning_of_month.strftime('%Y/%b'), eM.fetch("#{i.months.ago.beginning_of_month.strftime('%Y/%b')}", 0)]
      @postsYear << [i.months.ago.beginning_of_month.strftime('%Y/%b'), pM.fetch("#{i.months.ago.beginning_of_month.strftime('%Y/%b')}", 0)]
    end
    # @endusersYear << [Date.today.beginning_of_month.strftime('%Y/%b'), eM.fetch("#{Date.today.beginning_of_month.strftime('%Y/%b')}", 0)]
    # @postsYear << [Date.today.beginning_of_month.strftime('%Y/%b'), pM.fetch("#{Date.today.beginning_of_month.strftime('%Y/%b')}", 0)]
    # 期間別の会員者数、投稿数の集計データーここまで


    # 注意対象のユーザー一覧部分
    # すでにバッチ処理によりユーザースコアは採点されている。採点の詳細については batches/scoreアクションで確認する。
    # 今回はユーザースコアが -0.5を下回っているユーザーを一覧表示する
    @attentionTargetUsers = Enduser.where(score: -1.0..-0.5, is_deleted: false)
    # 注意対象のユーザー一覧部分ここまで


    #Twitter関係の統計一覧
    #TwSentiments, TwRelatedWordsテーブルにどういう値が入るかは lib/batch/entities.rb を参照
    @latest_twSentiment = TwSentiment.where(latest: true)[0]
    @latest_twRelatedWords = TwRelatedWord.where(latest:true)
    #Twitter関係の統計一覧ここまで
  end
end
