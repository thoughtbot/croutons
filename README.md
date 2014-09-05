# Croutons

Easy breadcrumbs for Rails apps.

## Usage

1. Include `Croutons::Controller` in `ApplicationController`
2. Call the `#breadcrumbs` helper in your layout or other views
3. Define a `BreadcrumbTrail` class, which inherits from
   `Croutons::BreadcrumbTrail`
4. Define missing methods on the `BreadcrumbTrail` class. For example, for
   the `admin/locations/index.html.erb` view you would define a
   `#admin_locations_index` method.

    In these methods you build up a breadcrumb trail by calling `#breadcrumb`
    with a label and an optional URL, and calling the methods for other views
    to build on existing trails. View assigns (i.e. the controller ivars) are
    available via the `#objects` method which returns a hash.

## License

MIT. See the LICENSE file for details.
