class people::yatatsu {
  #
  # osx
  #
  # Universal Access
  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom

  # Miscellaneous
  include osx::no_network_dsstores # disable creation of .DS_Store files on network shares
  include osx::software_update # download and install software updates

  # lib
  include java
  include php::5_4_17
  include mysql
  include wget
  include imagemagick
  include virtualbox
  include vagrant
  include heroku
  include memcached

  # app for develop
  include iterm2::stable
  include sequel_pro

  # app for utility
  include firefox
  include chrome
  include evernote
  include alfred
  include dropbox

  # via homebrew
  package {
    [
      'readline',
      'tmux',
      'reattach-to-user-namespace',
      'tig',
	  'httpd'
    ]:
  }

  # dotfile setting
  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source  => 'yatatsu/dotfiles'
  }

  package {
    'Kobito':
      source   => "http://kobito.qiita.com/download/Kobito_v1.8.6.zip",
      provider => compressed_app;
    'XtraFinder':
      source   => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
      provider => pkgdmg;
  }
  
  package {
    'zsh':
      install_options => [
        '--disable-etcdir'
      ];
     'emacs':
      install_options => [
        '--cocoa',
        '--use-git-head',
        '--HEAD',
      ]
  }
  
  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before  => Osx_chsh[$::luser];
  }
  
  osx_chsh { $::luser:
    shell   => "${boxen::config::homebrewdir}/bin/zsh";
  }
}
