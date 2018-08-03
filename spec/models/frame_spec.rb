# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'validations' do
    %i[status total_pins].each do |field|
      it { is_expected.to validate_presence_of field }
    end
  end
end
