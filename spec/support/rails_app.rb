class RailsApp
  PROJECT_ROOT = File.expand_path("../../..", __FILE__).freeze

  module Helpers
    def setup_rails_app(&block)
      RailsApp.new.setup(&block)
    end
  end

  def setup
    create_rails_app
    disable_class_caching
    customize_gemfile
    bundle
    yield self
    setup_database
    load_environment
  end

  def scaffold_model(name, *columns)
    in_app_directory do
      run "rails generate scaffold #{name} #{columns.join(' ')} --force"
    end
  end

  def add_croutons_mixin_to_application_controller
    transform_file(path("app/controllers/application_controller.rb")) do |content|
      content.sub(
        /^(class.*)$/,
        "require 'croutons/controller'\n\n\\1\n  include Croutons::Controller\n"
      )
    end
  end

  def add_to_view(name, content_to_add)
    transform_file(path("app/views/#{name}.html.erb")) do |content|
      content << content_to_add
    end
  end

  def add_breadcrumb_trail_class(source)
    File.write(path("app/models/breadcrumb_trail.rb"), source)
  end

  private

  def create_rails_app
    run "bundle exec rails new #{path} --skip-gemfile --skip-bundle "\
      "--skip-git --skip-keeps --skip-spring --skip-javascript "\
      "--skip-test-unit --no-rc --skip-sprockets --skip-bootsnap --force"
  end

  def disable_class_caching
    transform_file(path("config/environments/test.rb")) do |content|
      content.gsub(/^\s*config\.cache_classes.*$/, "config.cache_classes = false")
    end
  end

  def customize_gemfile
    File.open(path("Gemfile"), "w") do |f|
      f << "source 'https://rubygems.org'\n"
      f << "gem 'croutons', path: '#{PROJECT_ROOT}'\n"
      f << "gem 'rspec-rails', group: :test\n"
      f << "gem 'capybara', group: :test\n"
    end
  end

  def bundle
    in_app_directory do
      run "bundle"
    end
  end

  def setup_database
    in_app_directory do
      run "rake db:drop:all db:create:all db:migrate"
    end
  end

  def load_environment
    require path("config/environment.rb")
    require "rspec/rails"
  end

  def in_app_directory(&block)
    Dir.chdir(path, &block)
  end

  def run(command)
    `#{command}`
  end

  def transform_file(filename)
    content = File.read(filename)
    File.open(filename, "w") do |f|
      content = yield(content)
      f.write(content)
    end
  end

  def path(filename = "")
    File.join(PROJECT_ROOT, "spec", "dummy_app", filename)
  end
end

RSpec.configure do |config|
  config.include RailsApp::Helpers
end
