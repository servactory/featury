# frozen_string_literal: true

RSpec.describe Usual::Example1::Feature1 do
  describe "#enabled?" do
    subject(:perform) { described_class.enabled? }

    it { expect(perform).to be(true) }
  end

  describe "#disabled?" do
    subject(:perform) { described_class.disabled? }

    it { expect(perform).to be(false) }
  end

  describe "#enable" do
    subject(:perform) { described_class.enable }

    it { expect(perform).to be(true) }
  end

  describe "#disable" do
    subject(:perform) { described_class.disable }

    it { expect(perform).to be(false) }
  end
end
