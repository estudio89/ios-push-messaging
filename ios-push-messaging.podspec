Pod::Spec.new do |s|
  s.name = 'ios-push-messaging'
  s.version = '0.0.0'
  s.source_files = 'ios-push-messaging/*.{h,m}'
  s.dependency 'Syncing'
end