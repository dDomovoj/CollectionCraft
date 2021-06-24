Pod::Spec.new do |s|
  s.name = 'CollectionCraft'
  s.version = '1.0.5'
  s.summary = 'CollectionView wrapping library'
  s.swift_version = '5.4'

  s.homepage = 'https://github.com/dDomovoj/CollectionCraft'
  s.license = { :type => "MIT" }
  s.author = { 
    'Dzmitry Duleba' => 'dmitryduleba@gmail.com'
  }
  s.source = { :git => 'https://github.com/dDomovoj/CollectionCraft.git', :tag => s.version.to_s }
  s.framework = ["UIKit", "Foundation"]
  s.dependency 'DifferenceKit'
  s.dependency 'Sourcery', '~> 1.4'

  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/*.swift'
  s.resources = '.sourcery/.sourcery.yml', '.sourcery/Templates/*.swifttemplate'

end
