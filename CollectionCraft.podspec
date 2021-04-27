Pod::Spec.new do |s|
  s.name = 'CollectionCraft'
  s.version = '0.0.1'
  s.summary = 'CollectionView wrapping library'

  s.homepage = 'https://github.com/dDomovoj/CollectionCraft'
  s.license = { :type => "MIT" }
  s.author = { 
    'Dzmitry Duleba' => 'dmitryduleba@gmail.com'
  }
  s.source = { :git => 'https://github.com/dDomovoj/CollectionCraft.git', :tag => s.version.to_s }
  s.framework = ["UIKit", "Foundation"]
  s.dependency 'DifferenceKit'
  s.dependency 'Sourcery', '~> 0.18.0'

  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/*.swift'

end
