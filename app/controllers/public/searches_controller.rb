class Public::SearchesController < ApplicationController
  def index
    @word = params[:search]
    @endusers = search_enduser(@word)
  end

  private
  def search_enduser(word)
    Enduser.where('name LIKE ?', "%#{word}%")
  end

end
