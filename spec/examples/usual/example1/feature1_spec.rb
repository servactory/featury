# frozen_string_literal: true

RSpec.describe Usual::Example1::Feature1 do
  describe "#enabled?" do
    subject(:perform) { described_class.enabled? }

    it { expect(perform).to be(true) }
  end
end
