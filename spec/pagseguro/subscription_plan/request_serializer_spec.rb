require 'spec_helper'

describe PagSeguro::SubscriptionPlan::RequestSerializer do
  context '#to_xml_params' do
    subject { described_class.new(plan) }

    let(:plan) { PagSeguro::SubscriptionPlan.new }

    it 'should serializer max users' do
      plan.max_users = 300

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<maxUsers>300
        ]xm
    end

    it 'should serializer name' do
      plan.name = 'Private channel access'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<name>Private.channel.access
        ]xm
    end

    it 'should serializer details' do
      plan.details = 'To have access.'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<details>To.have.access.
        ]xm
    end

    it 'should serializer charge' do
      plan.charge = 'AUTO'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<charge>AUTO
        ]xm
    end

    it 'should serializer period' do
      plan.period = 'MONTHLY'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<period>MONTHLY
        ]xm
    end

    it 'should serializer amount' do
      plan.amount = 80

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<amountPerPayment>80.00
        ]xm
    end

    it 'should serializer max amount' do
      plan.max_amount = 35_000

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<maxTotalAmount>35000.00
        ]xm
    end

    it 'should serializer max amount per period' do
      plan.max_amount_per_period = 300

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<maxAmountPerPeriod>300.00
        ]xm
    end

    it 'should serializer final date' do
      plan.final_date = Time.new(2020, 12, 31, 18, 59)

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<finalDate>2020-12-31T.*
        ]xm
    end

    it 'should serializer membership fee' do
      plan.membership_fee = 150

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<membershipFee>150.00
        ]xm
    end

    it 'should serializer trial duration' do
      plan.trial_duration = 30.0

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<trialPeriodDuration>30
        ]xm
    end

    it 'should serializer redirect url' do
      plan.redirect_url = 'http://example.com/redirect'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<redirectURL>http://example.com/redirect
        ]xm
    end

    it 'should serializer review url' do
      plan.review_url = 'http://example.com/review'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<reviewURL>http://example.com/review
        ]xm
    end

    it 'should serializer reference' do
      plan.reference = 'ref1234'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<reference>ref1234
        ]xm
    end

    context "should serializer sender's" do
      before do
        plan.sender = {
          name: 'John',
          email: 'john@example.com',
          phone: { area_code: 11, number: 123 },
        }

        plan.sender_address = {
          street: 'Park Street',
          number: 12,
          complement: 'Complement here',
          district: 'Neighborhood',
          postal_code: '123456',
          city: 'São Paulo',
          state: 'SP',
          country: 'BRA'
        }
      end

      it 'name' do
        expect(subject.to_xml_params).to match %r[
          <preApprovalRequest>
            .*<sender>
              .*<name>John
          ]xm
      end

      it 'email' do
        expect(subject.to_xml_params).to match %r[
          <preApprovalRequest>
            .*<sender>
              .*<email>john@example.com
          ]xm
      end

      it 'phone' do
        expect(subject.to_xml_params).to match %r[
          <preApprovalRequest>
            .*<sender>
              .*<phone>
                .*<areaCode>11</areaCode>
                .*<number>123
          ]xm
      end

      it 'address' do
        expect(subject.to_xml_params).to match %r[
          <preApprovalRequest>
            .*<sender>
              .*<address>
                .*<street>Park.Street</street>
                .*<number>12</number>
                .*<complement>Complement.here</complement>
                .*<district>Neighborhood</district>
                .*<postalCode>123456</postalCode>
                .*<city>São.Paulo</city>
                .*<state>SP</state>
                .*<country>BRA</country>
          ]xm
      end
    end
  end
end
