# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewUserForm do
  describe '#save' do
    context 'with valid input' do
      let(:form) do
        described_class.new(
          email: 'user@example.org',
          password: 'password123',
          organisation_name: 'My Organisation'
        )
      end

      it 'creates a new user' do
        expect { form.save }.to change(User, :count).by(1)
      end

      it 'creates a new organisation' do
        expect { form.save }.to change(Organisation, :count).by(1)
      end

      it 'returns true' do
        expect(form.save).to be_truthy
      end
    end

    context 'with invalid input' do
      let(:form) do
        described_class.new(
          email: 'invalid_email',
          password: 'password123',
          organisation_name: ''
        )
      end

      it 'doesnt not create a new user' do
        expect { form.save }.not_to change(User, :count)
      end

      it 'doesnt not create a new organisation' do
        expect { form.save }.not_to change(Organisation, :count)
      end

      it 'returns false' do
        expect(form.save).to be_falsey
      end

      it 'adds errors to the form object' do
        form.save
        expect(form.errors.messages_for(:email)).to include('is invalid')
        expect(form.errors.messages_for(:organisation_name)).to include("can't be blank")
      end
    end
  end
end
