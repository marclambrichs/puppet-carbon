require 'spec_helper'
describe 'carbon' do

  context 'with defaults for all parameters' do
    it { should contain_class('carbon') }
  end
end
