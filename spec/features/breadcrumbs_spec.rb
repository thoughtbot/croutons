require "spec_helper"

describe "Breadcrumbs" do
  before(:all) do |test|
    setup_rails_app do |rails_app|
      rails_app.scaffold_model "Post", "title:string"
      rails_app.add_croutons_mixin_to_application_controller
      rails_app.add_to_view('posts/index', '<%= breadcrumbs %>')
      rails_app.add_to_view('posts/show', '<%= breadcrumbs role: params[:role] %>')
      rails_app.add_to_view('posts/new', '<%= breadcrumbs %>')
      rails_app.add_breadcrumb_trail_class <<-RUBY
        require "croutons/breadcrumb_trail"

        class BreadcrumbTrail < Croutons::BreadcrumbTrail
          private

          def posts_index
            breadcrumb("Posts", posts_path)
          end

          def posts_show
            if objects[:role] == "admin"
              posts_index
            end
            breadcrumb(objects[:post].title)
          end
        end
      RUBY
    end

    test.class.send :include, Capybara::DSL
    test.class.send :include, Rails.application.routes.url_helpers
  end

  it "are rendered on page" do
    post = Post.create!(title: "My first post")

    visit posts_path

    with_breadcrumbs do |items|
      expect(items.length).to eq 1
      expect(items.first).to have_content("Posts")
      expect(items.first).not_to have_css("a")
    end

    visit post_path(post, role: "admin")

    with_breadcrumbs do |items|
      expect(items.length).to eq 2
      expect(items.first).to have_link("Posts", href: posts_path)
      expect(items.last).to have_content(post.title)
      expect(items.last).not_to have_css("a")
    end

    visit post_path(post, role: "guest")

    with_breadcrumbs do |items|
      expect(items.length).to eq 1
      expect(items.first).to have_content(post.title)
      expect(items.first).not_to have_css("a")
    end
  end

  context "when not defined" do
    it "raises a helpful exception" do
      expect { visit new_post_path }.to raise_exception(/posts_new/)
    end
  end

  def with_breadcrumbs
    within(".breadcrumbs") do
      yield all("li")
    end
  end
end
