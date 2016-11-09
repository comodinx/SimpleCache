Pod::Spec.new do |s|

  s.name         = "SimpleCache"
  s.version      = "0.3.0"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.summary      = "Simple Cache written in Swift"
  s.homepage     = "https://github.com/comodinx/SimpleCache"
  s.authors      = { "Nicolas Molina" => "comodinx@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/comodinx/SimpleCache.git", :tag => s.version }

  s.source_files = "Sources/*.swift"

end
