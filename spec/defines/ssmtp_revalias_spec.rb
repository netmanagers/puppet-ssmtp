require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'ssmtp::revalias' do

  let(:title) { 'ssmtp::revalias' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42',
                  :revaliases_template => 'ssmtp/revaliases.erb',
                  :revaliases_file => '/etc/ssmtp/revaliases',
                  :concat_basedir => '/var/lib/puppet/concat'} }

  describe 'Test basic revaliases is created' do
    let(:params) { { :name    => 'sample1',
                     :from    => 'someone@somewhere.com',
                     :mailhub => 'some_mail_relay',
                     :enable  => true, } }

    it { should contain_concat__fragment('ssmtp_revaliases_sample1').with_target('/etc/ssmtp/revaliases').with_content("sample1:someone@somewhere.com:some_mail_relay\n")
    }
  end
end
