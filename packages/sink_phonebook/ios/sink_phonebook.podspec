Pod::Spec.new do |s|
  s.name             = 'sink_phonebook'
  s.version          = '0.1.0'
  s.summary          = 'Native iOS Phonebook Pigeon Plugin for TelSync'
  s.description      = 'Fast and secure native iOS Contacts framework integration for TelSync.'
  s.homepage         = 'https://github.com/RaganiTech/TelSync'
  s.license          = { :type => 'MIT', :text => 'MIT License' }
  s.author           = { 'TelSync Team' => 'https://github.com/RaganiTech/TelSync' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'
  s.swift_version = '5.0'
end

