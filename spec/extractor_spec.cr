require "./spec_helper"

require "yaml"

Spectator.describe Extractor do
  it "should have a VERSION constant" do
    expect(Extractor::VERSION).not_to be_empty
  end

  describe ".abort!" do
    it "should raise MetadataProcessor::Abort" do
      expect { subject.abort! }.to raise_error(Extractor::MetadataProcessor::Abort)
    end
  end

  let(fixtures_dir) { File.expand_path("spec/fixtures")   }
  let(file)         { File.join(fixtures_dir,"image.jpg") }
  let(data) do
    File.open(file,"rb") do |file|
      String.build(file.size) do |io|
        IO.copy(file,io)
      end
    end
  end

  alias ArgsTuple = Tuple(String, Extractor::MetaType, Extractor::MetaFormat, String, Extractor::MetaData)

  let(metadata_file) { File.join(fixtures_dir,"image-metadata.yml") }
  let(expected_metadata) do
    Array(ArgsTuple).from_yaml(File.read(metadata_file))
  end

  describe ".extract" do
    it "should extract metadata from a String" do
      findings = [] of ArgsTuple

      subject.extract(data) do |plugin_name,type,format,mime_type,data|
        findings << {plugin_name, type, format, mime_type, data}
      end

      expect(findings).to contain_elements(expected_metadata)
    end
  end

  describe ".extract_from" do
    it "should extract metadata from a file" do
      findings = [] of ArgsTuple

      subject.extract(data) do |plugin_name,type,format,mime_type,data|
        findings << {plugin_name, type, format, mime_type, data}
      end

      expect(findings).to contain_elements(expected_metadata)
    end
  end
end
