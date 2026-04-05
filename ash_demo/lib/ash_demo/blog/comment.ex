defmodule AshDemo.Blog.Comment do
  use Ash.Resource, otp_app: :ash_demo, domain: AshDemo.Blog, data_layer: AshPostgres.DataLayer

  postgres do
    table "comments"
    repo AshDemo.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:content, :author_name, :post_id]
  end

  attributes do
    uuid_primary_key :id

    attribute :content, :string do
      allow_nil? false
    end

    attribute :author_name, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :post, AshDemo.Blog.Post do
      allow_nil? false
    end
  end
end
