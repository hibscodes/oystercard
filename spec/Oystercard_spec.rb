require 'Oystercard'

describe Oystercard do
    let(:station){ double :entry_station }

    it "checks oystercard has a balance" do
        oystercard = Oystercard.new
        expect(subject.balance).to eq(0)
    end

    it "should respond to touch_in with station" do
        expect(subject).to respond_to(:touch_in).with(1).argument
    end

    it "should return the entry station" do
        subject.top_up(10)
        expect(subject.touch_in(station)).to eq(station)
    end

    it "should return nil for entry station upon touch out" do
        subject.top_up(10)
        subject.touch_in(station)
        expect(subject.touch_out).to eq nil
    end

    describe '#top_up' do
        it "can be able to top-up oystercard balance" do
            expect(subject).to respond_to(:top_up).with(1).argument
        end

        it "can top up balance" do
            expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
        end
    end

    it "raises an error if over top up limit" do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        subject.top_up(maximum_balance)
        expect{ subject.top_up 1 }.to raise_error 'Maximum balance of #{MAXIMUM_BALANCE} exceeded' 
    end

    describe '#deduct' do
        it "can be able to deduct from oystercard balance" do
            expect(subject).to respond_to(:deduct).with(1).argument
        end

        it "deducts money from oystercard" do
            expect{ subject.deduct 1 }.to change{ subject.balance }.by -1
        end
    end
    
    # it "checks oyster card is in journey" do
    #     expect(subject.in_journey?).to be_falsey
    # end

    it "checks oystercard is touched in" do
        subject.top_up(2)
        subject.touch_in(station)
        expect(subject.in_journey?).to be_truthy
    end
    
    it "checks oystercard is touched out" do
        subject.top_up(2)
        subject.touch_in(station)
        subject.touch_out
        expect(subject.in_journey?).to be_falsey
    end

    it "will not touch in if below minimum balance" do
     expect{ subject.touch_in(station) }.to raise_error "insufficient funds to touch in"    
    end

    it " will deduct correct amount" do
        subject.top_up(2)
        subject.touch_in(station)
        expect{ subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end

    it "should raise an error message at touch_in, if card was not touched out" do
        subject.top_up(2)
        subject.touch_in(station)
        expect{ subject.touch_in(station) }.to raise_error "card still in use, has not been touched out"
    end

    it "should raise an error message at touch_out, if card was not touched in" do
        subject.top_up(2)
        expect{ subject.touch_out }.to raise_error "card was not touched in" 
    end

    # it "checks oyster card is in journey" do
    #     expect(subject.in_journey?).to eq(true)
    # end

    # it "checks oystercard is touched in" do
    #     expect(subject.touch_in).to eq(:in_journey?)
    # end

    # it "checks oystercard is touched in" do
    #     expect(subject.touch_out).to eq(:in_journey?)
    # end
end