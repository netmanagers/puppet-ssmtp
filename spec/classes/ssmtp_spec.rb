require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'ssmtp' do

  let(:title) { 'ssmtp' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should contain_package('ssmtp').with_ensure('present') }
    it { should contain_file('ssmtp.conf').with_ensure('present') }
    it { should contain_file('ssmtp.conf').with_mode('0640') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('ssmtp').with_ensure('1.0.42') }
  end

  describe 'Test ssmtp.conf managed throuh template' do
    let(:facts) { {:operatingsystem => 'Debian' } }
    let(:params) do
      {
        :template          => 'ssmtp/ssmtp.conf.erb', 
        :auth_method       => 'cram-md5',
        :auth_user         => 'someuser',
        :auth_pass         => 'somepassword',
        :config_file_owner => 'mail',
        :config_file_group => 'other',
        :config_file_mode  => '0600'
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.
Root=postmaster
MailHub=mail
Hostname=rspec.example42.com
AuthUser=someuser
AuthPass=somepassword
AuthMethod=cram-md5
'
    end
    it { should contain_file('ssmtp.conf').without_source }
    it { should contain_file('ssmtp.conf').with_mode('0600').with_owner('mail').with_group('other') }
    it { should contain_file('ssmtp.conf').with_content(expected) }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[ssmtp]' do should contain_package('ssmtp').with_ensure('absent') end 
    it 'should remove ssmtp configuration file' do should contain_file('ssmtp.conf').with_ensure('absent') end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('ssmtp').with_noop('true') }
    it { should contain_file('ssmtp.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "ssmtp/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'ssmtp.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'ssmtp.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/ssmtp/spec"} }
    it { should contain_file('ssmtp.conf').with_source('puppet:///modules/ssmtp/spec') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "ssmtp::spec" } }
    it { should contain_file('ssmtp.conf').with_content(/rspec.example42.com/) }
  end

end
