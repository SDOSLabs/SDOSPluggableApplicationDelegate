@version = "1.0.0"
Pod::Spec.new do |spec|
  spec.platform     = :ios, '9.0'
  spec.name         = 'SDOSPluggableApplicationDelegate'
  spec.authors      = 'SDOS'
  spec.version      = @version
  spec.license      = { :type => 'SDOS License' }
  spec.homepage     = 'https://svrgitpub.sdos.es/iOS/SDOSPluggableApplicationDelegate'
  spec.summary      = 'Librería para el manejo de variables de entorno'
  spec.description  = <<-DESC
PluggableApplicationDelegate is a way of decoupling AppDelegate, by splitting it into small modules called ApplicationService.
Each ApplicationServices shares the life cycle with AppDelegate, and becomes its observer. Whenever AppDelegate runs any life cycle method, your Application services are notified and perform some action.
PluggableApplicationDelegate is an open class from which your AppDelegate needs to inherit. Your AppDelegate then needs to override its `services` property, returning an ApplicationServices array.
                       DESC
  spec.source       = { :git => "https://svrgitpub.sdos.es/iOS/SDOSPluggableApplicationDelegate.git", :tag => "v#{spec.version}" }
  spec.framework    = ['UIKit']
  spec.requires_arc = true
  spec.swift_version = '5.0'

  spec.subspec 'SDOSPluggableApplicationDelegate' do |s1|
    s1.preserve_paths = 'src/Classes/*'
    s1.source_files = ['src/Classes/*{*.m,*.h,*.swift}', 'src/Classes/**/*{*.m,*.h,*.swift}']
  end

end
