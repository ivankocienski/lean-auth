

require 'spec_helper'

describe "Root routing", type: :routing do
  it 'routes / to root controller' do
    expect( get: '/' ).to route_to(
      controller: "root",
      action: "index")
  end
end

