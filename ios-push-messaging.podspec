Pod::Spec.new do |s|
  s.name = 'ios-push-messaging'
  s.version = '0.0.1'
  s.source_files = 'ios-push-messaging/*.{h,m}'
  s.dependency 'Syncing'
  s.authors = 'Estúdio 89'
  s.license = 'GPL'
  s.homepage = 'https://github.com/estudio89/ios-push-messaging'
  s.summary = 'E89 iOS Push Messaging'
  s.source = { :git => 'https://github.com/estudio89/ios-push-messaging.git' }
end