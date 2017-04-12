require 'spec_helper'

describe Lita::Handlers::OnewheelBeerAbvpub, lita_handler: true do
  it { is_expected.to route_command('abvpub') }
  it { is_expected.to route_command('abvpub 4') }
  it { is_expected.to route_command('abvpub nitro') }
  it { is_expected.to route_command('abvpub CASK') }
  it { is_expected.to route_command('abvpub <$4') }
  it { is_expected.to route_command('abvpub < $4') }
  it { is_expected.to route_command('abvpub <=$4') }
  it { is_expected.to route_command('abvpub <= $4') }
  it { is_expected.to route_command('abvpub >4%') }
  it { is_expected.to route_command('abvpub > 4%') }
  it { is_expected.to route_command('abvpub >=4%') }
  it { is_expected.to route_command('abvpub >= 4%') }
  it { is_expected.to route_command('abvpubabvhigh') }
  it { is_expected.to route_command('abvpubabvlow') }

  before do
    mock = File.open('spec/fixtures/abvpub.html').read
    allow(RestClient).to receive(:get) { mock }
  end

  it 'shows the taps' do
    send_command 'abvpub'
    expect(replies.last).to include('taps: 1) Persnickety Pinot Gris  2) Nectar Creek Apis')
  end

  it 'displays details for tap 4' do
    send_command 'abvpub 4'
    expect(replies.last).to include('Abvpub tap 4) Passion Fruit - , 6.8%')
  end

  it 'doesn\'t explode on 1' do
    send_command 'abvpub 1'
    expect(replies.count).to eq(1)
    expect(replies.last).to eq('Abvpub tap 1) Pinot Gris - , 12.5%')
  end

  it 'searches for ipa' do
    send_command 'abvpub ipa'
    expect(replies.last).to include('Abvpub tap 18) IPA X Series: West Coast - , 6.7%')
  end

  it 'searches for abv >9%' do
    send_command 'abvpub >9%'
    expect(replies.count).to eq(6)
    expect(replies[0]).to eq('Abvpub tap 1) Pinot Gris - , 12.5%')
    expect(replies[1]).to eq('Abvpub tap 10) Sailor Mom - , 9.1%')
  end

  it 'runs a random beer through' do
    send_command 'abvpub roulette'
    expect(replies.count).to eq(1)
    expect(replies.last).to include('Abvpub tap')
  end

  it 'runs a random beer through' do
    send_command 'abvpub random'
    expect(replies.count).to eq(1)
    expect(replies.last).to include('Abvpub tap')
  end

  it 'displays hige abv' do
    send_command 'abvpubabvhigh'
    expect(replies.last).to eq('Abvpub tap 33) Farmhouse Red - , 13.5%')
  end

  it 'displays low abv' do
    send_command 'abvpubabvlow'
    expect(replies.last).to eq('Abvpub tap 8) Cactus Wins the Lottery - , 4.2%')
  end
end
