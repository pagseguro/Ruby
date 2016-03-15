require 'spec_helper'

RSpec.describe PagSeguro::SubscriptionCanceller::Response do
  subject { described_class.new(response, cancel) }

  let(:cancel) { PagSeguro::SubscriptionCanceller.new }

  context '#success?' do
    let(:response) do
      double(:HttpResponse, xml?: true)
    end

    it 'delegate to response' do
      allow(response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  describe '#serialize' do
    let(:response) do
      double(:HttpResponse, xml?: true, success?: true)
    end

    context 'when request succeeds' do
      it 'not change object errors' do
        expect { subject.serialize }.not_to change { cancel.errors.empty? }
      end
    end

    context 'when request fails' do
      let(:response) do
        double(
          :HttpResponse,
          data: parsed_xml,
          error: Aitch::BadRequestError,
          error?: true,
          success?: false,
          xml?: true
        )
      end

      let(:raw_xml) do
        File.read('./spec/fixtures/subscription_canceller/fail.xml')
      end

      let(:parsed_xml) do
        Nokogiri::XML(raw_xml)
      end

      it 'change errors' do
        expect { subject.serialize }.to change { cancel.errors.empty? }
      end
    end
  end
end
