describe MacAddresses do
  subject { MacAddresses }

  context 'attr_*' do
    it { is_expected.to have_attr_reader :addresses }
  end

  describe '::fetch' do
    it 'is expected to call ::from_getifaddrs' do
      expect(subject).to receive(:from_getifaddrs)
      MacAddresses.fetch
    end

    context 'when ::from_getifaddrs returns something' do
      let(:expected_addresses) { 'something' }

      before { allow(subject).to receive(:from_getifaddrs).and_return expected_addresses }

      it 'is expected to return @addresses' do
        expect(subject.fetch).to eq expected_addresses
      end
    end

    context 'when ::from_getifaddrs returns nil' do
      before { allow(subject).to receive(:from_getifaddrs).and_return nil }

      context 'when at least one of COMMANDS is available' do
        let(:command) { 'some_command' }
        let(:expected_addresses) { subject.parse(DataSupport.linux_ifconfig) }

        before do
          MacAddresses.send(:remove_const, :COMMANDS)
          MacAddresses::COMMANDS = command

          allow(MacAddresses).to receive(:`).with(command).and_return DataSupport.linux_ifconfig
        end
      end

      context 'when none of COMMANDS is available' do
        before do
          MacAddresses.send(:remove_const, :COMMANDS)
          MacAddresses::COMMANDS = []
        end

        it 'is expected to raise' do
          expect { subject.fetch }.to raise_error subject::Exceptions::NoneOfCommandsSuccessful
        end
      end
    end
  end

  describe '::from_getifaddrs' do

    context 'when Socket responds to ::getifaddrs' do
      let(:fake_ifaddr) { double('Socket::Ifaddr', addr: nil) }
      let(:fake_ifaddresses) { (1..10).inject([]) { |res, i| res << fake_ifaddr } }
      let(:expected_addresses) { [] }

      before { allow(Socket).to receive(:getifaddrs).and_return fake_ifaddresses }

      it 'is expected to return expected_addresses' do
        expect(subject.from_getifaddrs).to eq expected_addresses
      end
    end

    context 'when Socket does not respond to ::getifaddrs' do
      before { allow(Socket).to receive(:respond_to?).with(:getifaddrs).and_return false }

      it 'is expected to return  nil' do
        expect(subject.from_getifaddrs).to be_nil
      end
    end
  end

  describe '::parse' do
    let(:expected_candidates) { proc { |data| data.scan(subject::ADDRESS_REGEXP).map(&:strip) } }

    context 'when platform is MacOS' do

      context 'when command is ifconfig' do
        it 'is expected to return candidate addresses' do
          expect(subject.parse(DataSupport.platform_command(:macos, :ifconfig))).to eq expected_candidates[DataSupport.platform_command(:macos, :ifconfig)]
        end
      end
    end

    context 'when platform is Linux' do

      context 'when command is ifconfig' do
        it 'is expected to return candidate addresses' do
          expect(subject.parse(DataSupport.platform_command(:linux, :ifconfig))).to eq expected_candidates[DataSupport.platform_command(:linux, :ifconfig)]
        end
      end
    end

    context 'when no candidate addresses are available' do
      it 'is expected to return an empty Array' do
        expect(subject.parse '').to eq []
      end
    end
  end
end
