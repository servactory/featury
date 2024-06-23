# frozen_string_literal: true

RSpec.describe Usual::Example1::Main do
  let(:arguments) do
    {
      record: record,
      user: user
    }
  end

  let(:record) { Usual::Example1::Main::Record.new(id: "123") }
  let(:user) { Usual::Example1::Main::User.new(id: "456") }

  shared_examples "expected behavior" do
    describe "#enabled?" do
      subject(:perform) { feature_class.enabled? }

      before do
        allow(FeatureLib).to receive(:enabled?).with(:example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:example_1_e_iii).and_call_original
      end

      it { expect(perform).to be(true) }

      it { expect(FeatureLib.enabled?(:example_1_a, user)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_b, user)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_c, user)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_d_i)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_d_ii)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_d_iii)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_e_i)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_e_ii)).to be(true) }
      it { expect(FeatureLib.enabled?(:example_1_e_iii)).to be(true) }
    end

    describe "#disabled?" do
      subject(:perform) { feature_class.disabled? }

      before do
        allow(FeatureLib).to receive(:disabled?).with(:example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:example_1_e_iii).and_call_original
      end

      it { expect(perform).to be(false) }

      it { expect(FeatureLib.disabled?(:example_1_a, user)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_b, user)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_c, user)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_d_i)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_d_ii)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_d_iii)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_e_i)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_e_ii)).to be(false) }
      it { expect(FeatureLib.disabled?(:example_1_e_iii)).to be(false) }
    end

    describe "#enable" do
      subject(:perform) { feature_class.enable }

      before do
        allow(FeatureLib).to receive(:enable).with(:example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:example_1_e_iii).and_call_original
      end

      it { expect(perform).to be(true) }

      it { expect(FeatureLib.enable(:example_1_a, user)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_b, user)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_c, user)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_d_i)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_d_ii)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_d_iii)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_e_i)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_e_ii)).to be(true) }
      it { expect(FeatureLib.enable(:example_1_e_iii)).to be(true) }
    end

    describe "#disable" do
      subject(:perform) { feature_class.disable }

      before do
        allow(FeatureLib).to receive(:disable).with(:example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:example_1_e_iii).and_call_original
      end

      it { expect(perform).to be(true) }

      it { expect(FeatureLib.disable(:example_1_a, user)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_b, user)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_c, user)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_d_i)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_d_ii)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_d_iii)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_e_i)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_e_ii)).to be(true) }
      it { expect(FeatureLib.disable(:example_1_e_iii)).to be(true) }
    end
  end

  context "when `with` method is used" do
    let(:feature_class) { described_class.with(**arguments) }

    include_examples "expected behavior"
  end

  context "when `with` method is not used" do
    let(:feature_class) { described_class }

    include_examples "expected behavior"
  end
end
