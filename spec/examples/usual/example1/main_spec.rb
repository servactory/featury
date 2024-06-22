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

    it { expect(perform).to be(true) }
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
