# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GravatarHelper do
  describe '#user_avatar' do
    it 'returns a gravatar url' do
      user = build(:user, email: 'john@example.org')

      expect(helper.user_avatar(user)).to eq('https://www.gravatar.com/avatar/08aff750c4586c34375a0ebd987c1a7e')
    end

    it 'provides a sane default' do
      user = build(:user, email: nil)

      expect(helper.user_avatar(user)).to eq('https://www.gravatar.com/avatar/00000000000000000000000000000000')
    end
  end
end
