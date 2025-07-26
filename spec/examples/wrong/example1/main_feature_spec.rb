# frozen_string_literal: true

RSpec.describe Wrong::Example1::MainFeature do
  let(:arguments) do
    {}
  end

  shared_examples "expected successful behavior" do
    describe "#enabled?" do
      subject(:perform) { feature_class.enabled? }

      before do
        allow(FeatureLib).to receive(:enabled?).with(anything).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: []
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enabled?,
              features: []
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(true) }

      it do
        perform

        expect(FeatureLib).not_to have_received(:enabled?).with(anything)
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enabled?,
              features: []
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
              features: []
            )
            .once
        )
      end
    end

    describe "#disabled?" do
      subject(:perform) { feature_class.disabled? }

      before do
        allow(FeatureLib).to receive(:disabled?).with(anything).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: []
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :disabled?,
              features: []
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(false) }

      it do
        perform

        expect(FeatureLib).not_to have_received(:disabled?).with(anything)
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: []
            )
            .once
        )
      end

      it do
        perform

        expect(Services::Callback::After).to(
          have_received(:call!)
            .with(
              action: :disabled?,
              features: []
            )
            .once
        )
      end
    end

    describe "#enable" do
      subject(:perform) { feature_class.enable }

      before do
        allow(FeatureLib).to receive(:enable).with(anything).and_call_original

        allow(Services::Callback::Before).to(
          receive(:call!)
            .with(
              action: :enable,
              features: []
            )
            .and_call_original
        )
        allow(Services::Callback::After).to(
          receive(:call!)
            .with(
              action: :enable,
              features: []
            )
            .and_call_original
        )
      end

      it { expect(perform).to be(true) }

      it do
        perform

        expect(FeatureLib).not_to have_received(:enable).with(anything)
      end

      it do
        perform

        expect(Services::Callback::Before).to(
          have_received(:call!)
            .with(
              action: :enable,
              features: []
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
              features: []
            )
        )
      end

      describe "#disable" do
        subject(:perform) { feature_class.disable }

        before do
          allow(FeatureLib).to receive(:disable).with(anything).and_call_original

          allow(Services::Callback::Before).to(
            receive(:call!)
              .with(
                action: :disable,
                features: []
              )
              .and_call_original
          )
          allow(Services::Callback::After).to(
            receive(:call!)
              .with(
                action: :disable,
                features: []
              )
              .and_call_original
          )
        end

        it { expect(perform).to be(true) }

        it do
          perform

          expect(FeatureLib).not_to have_received(:disable).with(anything)
        end

        it do
          perform

          expect(Services::Callback::Before).to(
            have_received(:call!)
              .with(
                action: :disable,
                features: eq([])
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
                features: eq([])
              )
          )
        end
      end
    end
  end

  # shared_examples "expected unsuccessful behavior" do
  #   describe "#enabled?" do
  #     subject(:perform) { feature_class.enabled? }
  #
  #     it do
  #       expect { perform }.to raise_error(
  #         Featury::Service::Exceptions::Input,
  #         "[Wrong::Example1::MainFeature::SBuilder] Required resource `record` is missing"
  #       )
  #     end
  #   end
  #
  #   describe "#disabled?" do
  #     subject(:perform) { feature_class.disabled? }
  #
  #     it do
  #       expect { perform }.to raise_error(
  #         Featury::Service::Exceptions::Input,
  #         "[Wrong::Example1::MainFeature::SBuilder] Required resource `record` is missing"
  #       )
  #     end
  #   end
  #
  #   describe "#enable" do
  #     subject(:perform) { feature_class.enable }
  #
  #     it do
  #       expect { perform }.to raise_error(
  #         Featury::Service::Exceptions::Input,
  #         "[Wrong::Example1::MainFeature::SBuilder] Required resource `record` is missing"
  #       )
  #     end
  #   end
  #
  #   describe "#disable" do
  #     subject(:perform) { feature_class.disable }
  #
  #     it do
  #       expect { perform }.to raise_error(
  #         Featury::Service::Exceptions::Input,
  #         "[Wrong::Example1::MainFeature::SBuilder] Required resource `record` is missing"
  #       )
  #     end
  #   end
  # end

  context "when `with` method is used" do
    let(:feature_class) { described_class.with(**arguments) }

    it_behaves_like "expected successful behavior"
  end

  context "when `with` method is not used" do
    let(:feature_class) { described_class }

    it_behaves_like "expected successful behavior"
    # it_behaves_like "expected unsuccessful behavior"
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
      expect(perform.resources).to be_empty
    end

    it do
      expect(perform.features).to be_empty
    end

    it do
      expect(perform.groups).to be_empty
    end

    it do
      expect(perform.tree).to(
        have_attributes(
          features: be_empty,
          groups: be_empty
        )
      )
    end

    it { expect(feature_class.respond_to?(:featury?)).to be(true) }

    it { expect(feature_class.featury?).to be(true) }
  end
end
