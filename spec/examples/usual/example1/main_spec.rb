# frozen_string_literal: true

RSpec.describe Usual::Example1::Main do
  let(:arguments) do
    {
      record: Usual::Example1::Main::Record.new(id: "123"),
      user: Usual::Example1::Main::User.new(id: "456")
    }
  end

  describe "#enabled?" do
    subject(:perform) { described_class.enabled?(**arguments) }

    before do
      allow(FeatureLib).to receive(:enabled?).with(:example_1_a).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_b).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_c).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_d_i).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_d_ii).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_d_iii).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_e_i).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_e_ii).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_e_ii).and_call_original
      allow(FeatureLib).to receive(:enabled?).with(:example_1_e_iii).and_call_original
    end

    it { expect(perform).to be(true) }

    it { expect(FeatureLib.enabled?(:example_1_a)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_b)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_c)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_d_i)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_d_ii)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_d_iii)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_e_i)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_e_ii)).to be(true) }
    it { expect(FeatureLib.enabled?(:example_1_e_iii)).to be(true) }
  end

  describe "#disabled?" do
    subject(:perform) { described_class.disabled?(**arguments) }

    it { expect(perform).to be(false) }
  end

  describe "#enable" do
    subject(:perform) { described_class.enable(**arguments) }

    it { expect(perform).to be(true) }
  end

  describe "#disable" do
    subject(:perform) { described_class.disable(**arguments) }

    it { expect(perform).to be(false) }
  end
end
