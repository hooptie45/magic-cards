require 'rails_helper'

RSpec.describe IngestMagicSetListJob, type: :job do
  it "will pull url" do
    expect(described_class.new.perform).to eql []
  end
end
