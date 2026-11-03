Pod::Spec.new do |s|
  s.name             = 'sink_phonebook'
  s.version          = '0.1.0'
  s.summary          = 'Native phonebook Pigeon plugin for contact_bridge'
  s.description      = 'Native phonebook Pigeon plugin for contact_bridge'
  s.homepage         = 'https://github.com/example/contact_bridge'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Contact Bridge Team' => 'team@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'
  s.swift_version = '5.0'
end
