module Nanoc::Deploying
  # @api private
  module Deployers
    autoload 'Fog',   'nanoc/deploying/deployers/fog'
    autoload 'Git',   'nanoc/deploying/deployers/git'
    autoload 'Rsync', 'nanoc/deploying/deployers/rsync'

    Nanoc::Deploying::Deployer.register '::Nanoc::Deploying::Deployers::Fog',   :fog
    Nanoc::Deploying::Deployer.register '::Nanoc::Deploying::Deployers::Git',   :git
    Nanoc::Deploying::Deployer.register '::Nanoc::Deploying::Deployers::Rsync', :rsync
  end
end
