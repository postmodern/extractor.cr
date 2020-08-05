require "./spec_helper"

Spectator.describe Extractor::PluginList do
  let(plugin) { :wav }

  describe ".default" do
    it "should load the default plugins" do
      expect {
        described_class.default
      }.not_to raise_error
    end

    context "when no plugins could be loaded" do
      before_all { ENV["LIBEXTRACTOR_LIBRARIES"] = "/does/not/exist" }

      it "should raise PluginsLoadError" do
        expect {
          described_class.default
        }.to raise_error(Extractor::PluginsLoadError)
      end

      after_all { ENV.delete("LIBEXTRACTOR_LIBRARIES") }
    end
  end

  describe "#add" do
    it "should load an individual plugin" do
      subject.add(plugin)

      expect(subject.to_unsafe).not_to be_null
    end

    context "when given an invalid plugin name" do
      it "should raise PluginNotFound" do
        expect {
          subject.add("foo")
        }.to raise_error(Extractor::PluginNotFound)
      end
    end
  end

  describe "#remove" do
    before_each { subject.add(plugin) }

    it "should remove a plugin from the list" do
      subject.remove(plugin)
    end

    context "when given an plugin name not in the list" do
      it "should raise PluginNotFound" do
        expect {
          subject.remove("foo")
        }.to raise_error(Extractor::UnknownPlugin)
      end
    end
  end

  describe "#remove_all" do
    context "when the plugin list is not empty" do
      before_each { subject.add(plugin) }

      it "should remove all plugins in the list" do
        subject.remove_all
      end
    end

    context "when the plugin list is empty" do
      it "should no-op" do
        subject.remove_all
      end
    end
  end
end
