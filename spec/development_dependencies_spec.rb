require 'spec_helper'

RSpec.describe 'Development Dependencies Configuration' do
  it 'loads RSpec successfully' do
    expect(RSpec).to be_truthy
  end

  it 'loads FactoryBot successfully' do
    expect(FactoryBot).to be_truthy
  end

  it 'loads DatabaseCleaner successfully' do
    expect(DatabaseCleaner).to be_truthy
  end

  it 'loads the main Toolbox module' do
    expect(Toolbox).to be_truthy
  end
end