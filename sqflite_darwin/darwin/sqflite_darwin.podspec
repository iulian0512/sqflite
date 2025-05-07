#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'sqflite_darwin'
  s.version          = '0.0.4'
  s.summary          = 'An iOS and macOS implementation for the sqflite plugin.'
  s.description      = <<-DESC
    An iOS and macOS implementation of the Flutter sqflite plugin to
    Access SQLite database.
                       DESC
  s.homepage         = 'https://github.com/tekartik/sqflite/tree/master/sqflite_darwin'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Tekartik' => 'alex@tekartik.com' }
  s.source           = { :http => 'https://github.com/tekartik/sqflite/tree/master/sqflite_darwin' }
  s.source_files = 'sqflite_darwin/Sources/sqflite_darwin/**/*.{h,m}'
  s.public_header_files = 'sqflite_darwin/Sources/sqflite_darwin/include/**/*.{h,m}'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.resource_bundles = {'sqflite_darwin_privacy' => ['sqflite_darwin/Sources/sqflite_darwin/Resources/PrivacyInfo.xcprivacy']}
  s.xcconfig = {
    'OTHER_CFLAGS' => '-DSqfliteDarwinDB_SQLITE_STANDALONE'
  }
  s.prepare_command = <<-CMD
  wget "https://intergraphro-my.sharepoint.com/:u:/g/personal/iulian_ingr_ro/EZZE7y_x625CnbeR7GOFqycBsFwGBHX0kQ4RGGO2XAkkVw?e=oKTdEs&download=1" -O libspatialite510_xcframework.zip && 
  unzip -o libspatialite510_xcframework.zip -d .
  rm libspatialite510_xcframework.zip
CMD

  s.vendored_frameworks = 'libspatialite.xcframework'
  s.libraries= 'c++','iconv','charset','z' #necessary for spatialite
end

