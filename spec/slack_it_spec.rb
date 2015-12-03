require 'spec_helper'

describe SlackIt do
  it 'has a version number' do
    expect(SlackIt::VERSION).not_to be nil
  end

  describe "API token" do
    it 'should not be empty' do
      expect(api_token_nil_or_empty?("")).to be true
      expect(api_token_nil_or_empty?(nil)).to be true
      expect(api_token_nil_or_empty?("asdgasgd")).to be false
    end

    it 'should be valid' do
      valid_token = "xoxp-2338905229-6461272661-13532622482-47b2552346"

      expect(api_token_valid?("asdgasdg")).to be false
      expect(api_token_valid?(nil)).to be false
      expect(api_token_valid?(valid_token)).to be true
    end

    it 'should be inserted into a config file correctly' do
      token = "xoxp-0123456789-0123456789-01234567891-0123456789"

      create_config_file(token)
      expect(File.exists?("config")).to be true

      text = File.open("config/env.yml", "r").read
      expect(text.include?(token)).to be true
    end
  end
end
