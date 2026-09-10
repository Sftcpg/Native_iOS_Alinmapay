Pod::Spec.new do |s|

  s.name         = 'Ios_alinmapay'
  s.version      = '1.0.0'

  s.summary      = 'AlinmaPay iOS payment SDK.'

  s.description  = <<-DESC
    AlinmaPay iOS SDK for processing payment transactions.
  DESC

  s.homepage     = 'https://github.com/Sftcpg/Native_iOS_Alinmapay'

  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE'
  }

  s.author       = {
    'AlinmaPay' => 'alinmapaypg@gmail.com'
  }

  s.platform     = :ios, '13.0'

  s.swift_version = '5.0'

  s.source = {
    :git => 'https://github.com/Sftcpg/Native_iOS_Alinmapay.git',
    :tag => s.version.to_s
  }

  s.source_files = [
    'PaymentSDK.swift',
    'Configuration/**/*.swift',
    'Models/**/*.swift',
    'Network/**/*.swift',
    'Protocol/**/*.swift',
    'Navigation/**/*.swift',
    'Theme/**/*.swift',
    'Utilities/**/*.swift',
    'Views/**/*.swift'
  ]

  s.resources = [
    'Resources/**/*'
  ]

  s.frameworks = [
    'UIKit',
    'SwiftUI',
    'WebKit',
    'PassKit'
  ]

end
