require "spec_helper"
require "croutons/breadcrumb_trail"
require "croutons/breadcrumb"
require "rails"

describe Croutons::BreadcrumbTrail do
  describe ".breadcrumbs" do
    let(:trail) do
      Class.new(described_class) do
        def one
          breadcrumb("One", "/one")
        end

        def two
          one
          breadcrumb("Two", "/two")
        end

        def thing
          breadcrumb(objects[:thing])
        end

        def translated
          breadcrumb(t(objects[:key]))
        end

        def routes
          breadcrumb("Some path", some_path)
          breadcrumb("You are here")
        end
      end
    end

    context "for a known template identifier" do
      it "returns breadcrumbs" do
        expect(trail.breadcrumbs(:one)).to eq [
          Croutons::Breadcrumb.new("One"),
        ]
      end

      it "removes the URL from the final crumb" do
        expect(trail.breadcrumbs(:two)).to eq [
          Croutons::Breadcrumb.new("One", "/one"),
          Croutons::Breadcrumb.new("Two"),
        ]
      end

      it "makes the given objects available through #objects" do
        expect(trail.breadcrumbs(:thing, thing: "Foo")).
          to eq [Croutons::Breadcrumb.new("Foo")]
        expect(trail.breadcrumbs(:thing, "thing" => "Bar")).
          to eq [Croutons::Breadcrumb.new("Bar")]
      end

      it "makes I18n available" do
        allow(I18n).to receive(:t).
          with("some.translation").
          and_return("translated string")
        expect(trail.breadcrumbs(:translated, key: "some.translation")).
          to eq [Croutons::Breadcrumb.new("translated string")]
      end

      it "makes Rails route helpers available" do
        route_helpers = double("route_helpers", some_path: "/some/path")
        allow(Rails).
          to receive_message_chain(:application, :routes, :url_helpers).
          and_return(route_helpers)

        expect(trail.breadcrumbs(:routes)).to eq [
          Croutons::Breadcrumb.new("Some path", "/some/path"),
          Croutons::Breadcrumb.new("You are here"),
        ]
      end
    end

    context "for an unknown template identifier" do
      it "raises a helpful exception" do
        expect { trail.breadcrumbs(:not_real) }.
          to raise_exception(NoMethodError)
      end
    end
  end
end
