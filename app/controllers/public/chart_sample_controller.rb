class Public::ChartSampleController < ApplicationController
  def index
  #配列形式でデータを用意する
      now = Time.current
      # c で current_enduser の投稿が何日に何個良いねされたかを集計している。{"2020-07-28"=>4, "2020-08-06"=>3} みたな感じでハッシュで値が返る
      # -concernsとpostsをjoinしたテーブルを作って,その中からpostテーブルのenduser_idがログインユーザと同じものを検索で取得
      # -そして、取得したものをconcernsレコードの作成日ごとにグループ分けし、そのグループごとの数を数える(何日に何個気になる！をもらったか数える)

      # 一週間ごとのお気に入り数のグラフを作成
      c = Concern.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group("DATE(concerns.created_at)").count
      @concerns_week = [
        [6.days.ago.strftime('%b/%d'), c.fetch("#{6.days.ago.strftime('%F')}", 0)],
        [5.days.ago.strftime('%d'), c.fetch("#{5.days.ago.strftime('%F')}", 0)],
        [4.days.ago.strftime('%d'), c.fetch("#{4.days.ago.strftime('%F')}", 0)],
        [3.days.ago.strftime('%d'), c.fetch("#{3.days.ago.strftime('%F')}", 0)],
        [2.days.ago.strftime('%d'), c.fetch("#{2.days.ago.strftime('%F')}", 0)],
        [1.days.ago.strftime('%d'), c.fetch("#{1.days.ago.strftime('%F')}", 0)],
        [now.strftime('%b/%d'), c.fetch("#{now.strftime('%F')}", 0)]
      ]
      @sumConcerns_week = @concerns_week.transpose[1].sum
      # 一週間ごとのお気に入り数のグラフを作成ここまで

      # 一週間ごとの自分の投稿に対してもらったコメント数のグラフを作成
      c2 = Comment.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group("DATE(comments.created_at)").count
      @comments_week = [
        [6.days.ago.strftime('%b/%d'), c2.fetch("#{6.days.ago.strftime('%F')}", 0)],
        [5.days.ago.strftime('%d'), c2.fetch("#{5.days.ago.strftime('%F')}", 0)],
        [4.days.ago.strftime('%d'), c2.fetch("#{4.days.ago.strftime('%F')}", 0)],
        [3.days.ago.strftime('%d'), c2.fetch("#{3.days.ago.strftime('%F')}", 0)],
        [2.days.ago.strftime('%d'), c2.fetch("#{2.days.ago.strftime('%F')}", 0)],
        [1.days.ago.strftime('%d'), c2.fetch("#{1.days.ago.strftime('%F')}", 0)],
        [now.strftime('%b/%d'), c.fetch("#{now.strftime('%F')}", 0)]
      ]
      @sumComments_week = @comments_week.transpose[1].sum
      # 一週間ごとの自分の投稿に対してもらったコメント数のグラフを作成ここまで

      # 年間で自分の投稿に対してもらったお気に入り数のグラフを作成
      c3 = Concern.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group_by_month("concerns.created_at", format: '%F').count
      @concerns_year = [
        [11.months.ago.beginning_of_month.strftime('%Y/%b'), c3.fetch("#{11.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [10.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{10.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [9.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{9.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [8.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{8.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [7.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{7.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [6.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{6.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [5.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{5.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [4.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{4.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [3.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{3.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [2.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{2.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [1.months.ago.beginning_of_month.strftime('%b'), c3.fetch("#{1.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [now.beginning_of_month.strftime('%Y/%b'), c3.fetch("#{now.beginning_of_month.strftime('%F')}", 0)]
      ]
      @sumConcerns_year = @concerns_year.transpose[1].sum
      # 年間で自分の投稿に対してもらったお気に入り数のグラフを作成ここまで

      # 年間で自分の投稿に対してもらったコメント数のグラフを作成
      c4 = Comment.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group_by_month("comments.created_at", format: '%F').count
      @comments_year = [
        [11.months.ago.beginning_of_month.strftime('%Y/%b'), c4.fetch("#{11.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [10.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{10.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [9.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{9.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [8.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{8.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [7.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{7.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [6.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{6.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [5.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{5.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [4.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{4.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [3.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{3.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [2.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{2.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [1.months.ago.beginning_of_month.strftime('%b'), c4.fetch("#{1.months.ago.beginning_of_month.strftime('%F')}", 0)],
        [now.beginning_of_month.strftime('%Y/%b'), c4.fetch("#{now.beginning_of_month.strftime('%F')}", 0)]
      ]
      @sumComments_year = @comments_year.transpose[1].sum
      # 年間で自分の投稿に対してもらったお気に入り数のグラフを作成ここまで
  end

  private
end
