defmodule AshDemo.Blog do
  use Ash.Domain,
    otp_app: :ash_demo

  resources do
    resource AshDemo.Blog.Post
    resource AshDemo.Blog.Comment
  end
end
