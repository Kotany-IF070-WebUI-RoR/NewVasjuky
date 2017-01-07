require 'rails_helper'

RSpec.describe 'Factory Girl' do
  FactoryGirl.factories.map(&:name).each do |f|
    describe "#{f} factory" do
      # Test each factory
      it 'is valid' do
        factory = FactoryGirl.build(f)
        if factory.respond_to?(:valid?)
          expect(factory).to be_valid,
                             -> { factory.errors.full_messages.join('\n') }
        end
      end

      FactoryGirl.factories[f].definition.defined_traits.map(&:name).each do |t|
        context "with trait #{t}" do
          it 'is valid' do
            factory = FactoryGirl.build(f, t)
            if factory.respond_to?(:valid?)
              expect(factory).to be_valid,
                                 -> { factory.errors.full_messages.join('\n') }
            end
          end
        end
      end
    end
  end
end
