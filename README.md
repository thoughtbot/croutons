Croutons
========

Easy breadcrumbs for Rails apps.

Usage
-----

### Required steps

1. Include `Croutons::Controller` in your `ApplicationController`.

   This will make a `#breadcrumbs` helper available in your layouts and views.
2. Call the `#breadcrumbs` helper in your layouts or views.
3. Define a `BreadcrumbTrail` class, which inherits from
   `Croutons::BreadcrumbTrail`.
4. Define missing methods on the `BreadcrumbTrail` class.

   For example, for the `admin/locations/index.html.erb` view you would define
   an `#admin_locations_index` method.

   In these methods, you build up a breadcrumb trail by calling `#breadcrumb`
   with a label and an optional URL. You can also call previously defined
   methods to build on existing trails. View assigns (i.e. the controller
   instance variables) are available via the `#objects` method which returns a
   `Hash`. Rails route helpers are also available inside this class.

Please see [the example below](#example) for further reference.

### Optional steps

* Instead of defining a `BreadcrumbTrail` class you can use an object of your
  own that responds to `#breadcrumbs`.

  To do this, override the private `#breadcrumb_trail` method in the controller
  where you included `Croutons::Controller`, to return the object you want to
  use.

  The `#breadcrumbs` method is passed two parameters: one `template_identifier`
  `String` and one `objects` `Hash`. The `#breadcrumbs` method should return an
  `Array` of `Croutons::Breadcrumb`s.

* Override the view used to render breadcrumbs.

  To do this, create a view called `breadcrumbs/_breadcrumbs.html.erb`.

  In this view, an `Array` of `Croutons::Breadcrumb`s is assigned to the local
  variable `breadcrumbs`. These `Croutons::Breadcrumb`s have two public
  attributes: `#label` and `#url`. The `#url` attribute is optional. To check
  whether the `Croutons::Breadcrumb` has a `#url` or not (i.e. should be
  rendered as a link or not), check whether the `#link?` method returns `true`
  or `false`.

### Example

#### `app/controllers/application_controller.rb`

    class ApplicationController < ActionController::Base
      include Croutons::Controller
    end

#### `app/controllers/posts_controller.rb`

    class PostsController < ApplicationController
      def index
        @posts = Post.all
      end

      def show
        @post = Post.find(params[:id])
      end
    end

#### `app/views/layouts/application.html.erb`

    <!DOCTYPE html>
    <html>
      <head>
        <title>My blog</title>
      </head>
      <body>
        <%= breadcrumbs %>
        <%= yield %>
      </body>
    </html>

#### `app/models/breadcrumb_trail.rb`

    class BreadcrumbTrail < Croutons::BreadcrumbTrail
      def posts_index
        breadcrumb("Posts", posts_path)
      end

      def posts_show
        posts_index
        breadcrumb(objects[:post].title, post_path(objects[:post]))
      end
    end

License
-------

Croutons is Copyright © 2014 Calle Erlandsson, George Brocklehurst, and
thoughtbot. It is free software, and may be redistributed under the terms
specified in the LICENSE file.

<!-- START /templates/footer.md -->
## About thoughtbot

![thoughtbot](https://thoughtbot.com/thoughtbot-logo-for-readmes.svg)

This repo is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community].
We are [available for hire][hire].

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github

<!-- END /templates/footer.md -->
