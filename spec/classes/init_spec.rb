require 'spec_helper'

describe 'libvirt' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to create_class('libvirt') }
        it { is_expected.to contain_package('libvirt').with_ensure('latest') }
        it { is_expected.to contain_package('virt-viewer').with_ensure('latest') }
        it { is_expected.to contain_service('libvirtd').with_ensure('running') }

        if (['RedHat', 'CentOS'].include?(os_facts[:operatingsystem]))
          if (os_facts[:operatingsystemmajrelease].to_s >= '7')
            it { is_expected.to contain_package('virt-install').with_ensure('latest') }
          else
            it { is_expected.to contain_package('python-virtinst').with_ensure('latest') }
          end
        end
      end
    end
  end
end
