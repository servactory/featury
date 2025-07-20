# frozen_string_literal: true

RSpec.describe Usual::Example1::MainFeature do
  let(:arguments) do
    {
      record:,
      user:
    }
  end

  let(:record) { Usual::Example1::MainFeature::Record.new(id: "123") }
  let(:user) { Usual::Example1::MainFeature::User.new(id: "456") }

  shared_examples "expected behavior" do
    describe "#enabled?" do
      subject(:perform) { feature_class.enabled? }

      before do
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_e_iii).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(true) }

      it { expect(FeatureLib.enabled?(:usual_example_1_a, user)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_b, user)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_c, user)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_d_i)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_d_ii)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_d_iii)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_e_i)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_e_ii)).to be(true) }
      it { expect(FeatureLib.enabled?(:usual_example_1_e_iii)).to be(true) }

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .once
        )
      end
    end

    describe "#disabled?" do
      subject(:perform) { feature_class.disabled? }

      before do
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_e_iii).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(false) }

      it { expect(FeatureLib.disabled?(:usual_example_1_a, user)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_b, user)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_c, user)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_d_i)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_d_ii)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_d_iii)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_e_i)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_e_ii)).to be(false) }
      it { expect(FeatureLib.disabled?(:usual_example_1_e_iii)).to be(false) }

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).not_to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::Before).not_to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::After).to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
        )
      end
    end

    describe "#enable" do
      subject(:perform) { feature_class.enable }

      before do
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_e_iii).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(true) }

      it { expect(FeatureLib.enable(:usual_example_1_a, user)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_b, user)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_c, user)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_d_i)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_d_ii)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_d_iii)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_e_i)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_e_ii)).to be(true) }
      it { expect(FeatureLib.enable(:usual_example_1_e_iii)).to be(true) }

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :enable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
        )
      end
    end

    describe "#disable" do
      subject(:perform) { feature_class.disable }

      before do
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_a, user).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_b, user).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_c, user).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_d_i).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_d_ii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_d_iii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_e_i).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_e_ii).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_e_iii).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(true) }

      it { expect(FeatureLib.disable(:usual_example_1_a, user)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_b, user)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_c, user)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_d_i)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_d_ii)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_d_iii)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_e_i)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_e_ii)).to be(true) }
      it { expect(FeatureLib.disable(:usual_example_1_e_iii)).to be(true) }

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_a usual_example_1_b usual_example_1_c]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_d_i usual_example_1_d_ii usual_example_1_d_iii]
            )
        )
      end

      it do
        perform

        expect(Services::Callback::After).not_to(
          have_received(:call!)
            .with(
              action: :disable,
              features: %i[usual_example_1_e_i usual_example_1_e_ii usual_example_1_e_iii]
            )
        )
      end
    end
  end

  context "when `with` method is used" do
    let(:feature_class) { described_class.with(**arguments) }

    it_behaves_like "expected behavior"
  end

  context "when `with` method is not used" do
    let(:feature_class) { described_class }

    it_behaves_like "expected behavior"
  end

  describe "#info" do
    subject(:perform) { feature_class.info }

    let(:feature_class) { described_class }

    it { expect(feature_class.respond_to?(:info)).to be(true) }

    it { expect(perform).to(be_instance_of(Featury::Info::Result)) }

    it do
      expect(perform.features).to contain_exactly(
        :usual_example_1_a,
        :usual_example_1_b,
        :usual_example_1_c
      )
    end

    it do
      expect(perform.groups).to contain_exactly(
        Usual::Example1::DFeature,
        Usual::Example1::EFeature
      )
    end

    it do
      expect(perform.tree).to contain_exactly(
        :usual_example_1_a,
        :usual_example_1_b,
        :usual_example_1_c,
        contain_exactly(
          :usual_example_1_d_i,
          :usual_example_1_d_ii,
          :usual_example_1_d_iii
        ),
        contain_exactly(
          :usual_example_1_e_i,
          :usual_example_1_e_ii,
          :usual_example_1_e_iii
        )
      )
    end

    it { expect(feature_class.respond_to?(:featury?)).to be(true) }

    it { expect(feature_class.featury?).to be(true) }
  end
end
