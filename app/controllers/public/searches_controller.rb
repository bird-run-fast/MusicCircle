class Public::SearchesController < ApplicationController
  def index
    @allTags = Tag.all.limit(40)
    @posts = []

    if params[:searchUser]
      @word = params[:searchUser]
      @endusers = search_enduser(@word)
      @endusers.each do |enduser|
        @tempPosts = enduser.posts
        @posts += @tempPosts.includes([:post_tags, :tags, :enduser])
      end
    elsif params[:searchTag]
      @word = params[:searchTag]
      @tags = search_tag(@word)
      @tags.each do |tag|
        @tempPosts = tag.posts
        @posts += @tempPosts.includes([:post_tags, :tags, :enduser])
      end
    end
  end

  private
  def search_tag(word)
    Tag.where('name LIKE ?', "%#{word}%").includes(:posts)
  end

  def search_enduser(word)
    Enduser.where('name LIKE ?', "%#{word}%").includes(:posts)
  end
end
