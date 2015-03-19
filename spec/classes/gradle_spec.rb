require 'spec_helper'

describe 'gradle' do

  context 'default' do
    it do
      should contain_file('/etc/profile.d/gradle.sh').with({
        'ensure' => 'file',
        'mode' => '0644'
      })
    end

    it 'should generate valid content' do
      content = catalogue.resource('file', '/etc/profile.d/gradle.sh').send(:parameters)[:content]
      content.should include('export GRADLE_HOME=/opt/gradle-1.8')
      content.should include('export PATH="$PATH:/opt/gradle-1.8/bin"')
      content.should include('export GRADLE_OPTS="-Dorg.gradle.daemon=true"')
    end
  end

  context 'custom target' do
    let(:params) { { :target => '/usr/local' } }

    it 'should generate valid content' do
      content = catalogue.resource('file', '/etc/profile.d/gradle.sh').send(:parameters)[:content]
      content.should include('export GRADLE_HOME=/usr/local/gradle-1.8')
      content.should include('export PATH="$PATH:/usr/local/gradle-1.8/bin"')
    end
  end

  context 'no daemon' do
    let(:params) { { :daemon => false } }

    it 'should generate valid content' do
      content = catalogue.resource('file', '/etc/profile.d/gradle.sh').send(:parameters)[:content]
      content.should_not include('export GRADLE_OPTS="-Dorg.gradle.daemon=true"')
    end
  end
end
