defmodule AshDemo.Blog.Post do
  use Ash.Resource, otp_app: :ash_demo, domain: AshDemo.Blog, data_layer: AshPostgres.DataLayer

  postgres do
    table "posts"
    repo AshDemo.Repo
  end

  code_interface do
    define :create, args: [:author_name]
    define :get_by_id, action: :read, get_by: :id
  end

  actions do
    defaults [:update, :destroy]
    default_accept [:title, :body, :author_name]

    create :create do
      validate attribute_in(:author_name, ["Meraj"])
    end

    read :read do
      prepare build(load: [:comments])
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints min_length: 3, max_length: 100
    end

    attribute :body, :string do
      allow_nil? false
      constraints min_length: 10
    end

    attribute :author_name, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :comments, AshDemo.Blog.Comment
  end
end
