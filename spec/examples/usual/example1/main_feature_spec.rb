# frozen_string_literal: true

RSpec.describe Usual::Example1::MainFeature do
  let(:arguments) do
    {
      record:,
      user:,
      thing_a:,
      thing_b:
    }
  end

  let(:record) { Usual::Example1::MainFeature::Record.new(id: "111") }
  let(:user) { Usual::Example1::MainFeature::User.new(id: "222") }
  let(:thing_a) { Usual::Example1::MainFeature::Thing.new(id: "333") }
  let(:thing_b) { Usual::Example1::MainFeature::Thing.new(id: "444") }

  let(:expected_resources_for_options) { [user, thing_a] }

  shared_examples "expected successful behavior" do
    describe "#enabled?" do
      subject(:perform) { feature_class.enabled? }

      before do
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_a,
                                                     *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_b,
                                                     *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:enabled?).with(:usual_example_1_c,
                                                     *expected_resources_for_options).and_call_original
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

      it :aggregate_failures do
        perform

        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_a, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_b, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_c, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_d_i).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_d_ii).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_d_iii).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_e_i).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_e_ii).once
        expect(FeatureLib).to have_received(:enabled?).with(:usual_example_1_e_iii).once
      end

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
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_a,
                                                      *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_b,
                                                      *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:disabled?).with(:usual_example_1_c,
                                                      *expected_resources_for_options).and_call_original
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

      it :aggregate_failures do
        perform

        expect(FeatureLib).to have_received(:disabled?).with(:usual_example_1_a, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:disabled?).with(:usual_example_1_b, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:disabled?).with(:usual_example_1_c, *expected_resources_for_options).once
        expect(FeatureLib).not_to have_received(:disabled?).with(:usual_example_1_d_i)
        expect(FeatureLib).not_to have_received(:disabled?).with(:usual_example_1_d_ii)
        expect(FeatureLib).not_to have_received(:disabled?).with(:usual_example_1_d_iii)
        expect(FeatureLib).not_to have_received(:disabled?).with(:usual_example_1_e_i)
        expect(FeatureLib).not_to have_received(:disabled?).with(:usual_example_1_e_ii)
        expect(FeatureLib).not_to have_received(:disabled?).with(:usual_example_1_e_iii)
      end

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
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_a,
                                                   *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_b,
                                                   *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:enable).with(:usual_example_1_c,
                                                   *expected_resources_for_options).and_call_original
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

      it :aggregate_failures do
        perform

        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_a, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_b, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_c, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_d_i).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_d_ii).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_d_iii).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_e_i).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_e_ii).once
        expect(FeatureLib).to have_received(:enable).with(:usual_example_1_e_iii).once
      end

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
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_a,
                                                    *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_b,
                                                    *expected_resources_for_options).and_call_original
        allow(FeatureLib).to receive(:disable).with(:usual_example_1_c,
                                                    *expected_resources_for_options).and_call_original
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

      it :aggregate_failures do
        perform

        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_a, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_b, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_c, *expected_resources_for_options).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_d_i).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_d_ii).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_d_iii).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_e_i).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_e_ii).once
        expect(FeatureLib).to have_received(:disable).with(:usual_example_1_e_iii).once
      end

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

  shared_examples "expected unsuccessful behavior" do
    describe "#enabled?" do
      subject(:perform) { feature_class.enabled? }

      it do
        expect { perform }.to raise_error(
          Featury::Service::Exceptions::Input,
          "[Usual::Example1::MainFeature::SBuilder] Required resource `record` is missing"
        )
      end
    end

    describe "#disabled?" do
      subject(:perform) { feature_class.disabled? }

      it do
        expect { perform }.to raise_error(
          Featury::Service::Exceptions::Input,
          "[Usual::Example1::MainFeature::SBuilder] Required resource `record` is missing"
        )
      end
    end

    describe "#enable" do
      subject(:perform) { feature_class.enable }

      it do
        expect { perform }.to raise_error(
          Featury::Service::Exceptions::Input,
          "[Usual::Example1::MainFeature::SBuilder] Required resource `record` is missing"
        )
      end
    end

    describe "#disable" do
      subject(:perform) { feature_class.disable }

      it do
        expect { perform }.to raise_error(
          Featury::Service::Exceptions::Input,
          "[Usual::Example1::MainFeature::SBuilder] Required resource `record` is missing"
        )
      end
    end
  end

  context "when `with` method is used" do
    let(:feature_class) { described_class.with(**arguments) }

    context "when optional resources are passed" do
      it_behaves_like "expected successful behavior"
    end

    context "when optional resources are not passed" do
      let(:arguments) do
        {
          record:,
          user:
        }
      end

      let(:expected_resources_for_options) { [user] }

      it_behaves_like "expected successful behavior"
    end
  end

  context "when `with` method is not used" do
    let(:feature_class) { described_class }

    it_behaves_like "expected unsuccessful behavior"
  end

  describe "#info" do
    subject(:perform) { feature_class.info }

    let(:feature_class) { described_class }

    it { expect(feature_class.respond_to?(:info)).to be(true) }

    it { expect(perform).to(be_instance_of(Featury::Info::Result)) }

    it do # rubocop:disable RSpec/ExampleLength
      expect(perform.actions).to(
        have_attributes(
          all: contain_exactly(
            :enabled?,
            :disabled?,
            :enable,
            :disable,
            :add
          ),
          web: have_attributes(
            all: contain_exactly(
              :enabled?,
              :disabled?,
              :enable,
              :disable,
              :add
            ),
            enabled: eq(:enabled?),
            enable: eq(:enable),
            disable: eq(:disable)
          )
        )
      )
    end

    it do
      expect(perform.resources).to contain_exactly(
        :record,
        :user,
        :thing_a,
        :thing_b
      )
    end

    it do
      expect(perform.features).to(
        contain_exactly(
          have_attributes(
            name: :usual_example_1_a,
            description: "A feature"
          ),
          have_attributes(
            name: :usual_example_1_b,
            description: "B feature"
          ),
          have_attributes(
            name: :usual_example_1_c,
            description: "C feature"
          )
        )
      )
    end

    it do
      expect(perform.groups).to(
        contain_exactly(
          have_attributes(
            group_class: Usual::Example1::DFeature,
            description: "D feature group"
          ),
          have_attributes(
            group_class: Usual::Example1::EFeature,
            description: "E feature group"
          )
        )
      )
    end

    it do # rubocop:disable RSpec/ExampleLength
      expect(perform.tree).to(
        have_attributes(
          features: contain_exactly(
            have_attributes(
              name: :usual_example_1_a,
              description: "A feature"
            ),
            have_attributes(
              name: :usual_example_1_b,
              description: "B feature"
            ),
            have_attributes(
              name: :usual_example_1_c,
              description: "C feature"
            )
          ),
          groups: contain_exactly(
            have_attributes(
              features: contain_exactly(
                have_attributes(
                  name: :usual_example_1_d_i,
                  description: "D I feature"
                ),
                have_attributes(
                  name: :usual_example_1_d_ii,
                  description: "D II feature"
                ),
                have_attributes(
                  name: :usual_example_1_d_iii,
                  description: "D III feature"
                )
              )
            ),
            have_attributes(
              features: contain_exactly(
                have_attributes(
                  name: :usual_example_1_e_i,
                  description: "E I feature"
                ),
                have_attributes(
                  name: :usual_example_1_e_ii,
                  description: "E II feature"
                ),
                have_attributes(
                  name: :usual_example_1_e_iii,
                  description: "E III feature"
                )
              )
            )
          )
        )
      )
    end

    it { expect(feature_class.respond_to?(:featury?)).to be(true) }

    it { expect(feature_class.featury?).to be(true) }
  end
end
