# frozen_string_literal: true

RSpec.describe Featury::VERSION do
  it { expect(Featury::VERSION::STRING).to be_present }
end
