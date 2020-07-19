class Post < ApplicationRecord
  belongs_to :enduser

  enum is_valid: {募集中:0, 募集終了:1}
end
