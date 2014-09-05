require "spec_helper"
require "croutons/breadcrumb"

describe Croutons::Breadcrumb do
  describe "#labelize" do
    it "sets url to nil" do
      breadcrumb = described_class.new("Some text", "Some url")

      breadcrumb.labelize

      expect(breadcrumb.url).to be_nil
    end
  end

  describe "#link?" do
    it "returns true when the url is present" do
      expect(described_class.new("Some text", "Some url")).to be_link
    end

    it "returns false when the url is blank" do
      expect(described_class.new("Some text", nil)).not_to be_link
    end
  end

  describe "#==" do
    it "returns true when the label and URL match" do
      one = described_class.new("label", "url")
      two = described_class.new("label", "url")

      expect(one).to eq(two)
    end

    it "returns false when the labels differ" do
      one = described_class.new("label", "url")
      two = described_class.new("other", "url")

      expect(one).not_to eq(two)
    end

    it "returns false when the URLs differ" do
      one = described_class.new("label", "url")
      two = described_class.new("label", "other")

      expect(one).not_to eq(two)
    end
  end
end
