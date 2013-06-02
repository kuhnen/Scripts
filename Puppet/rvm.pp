

Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

define rvm_for(
        $site="https://get.rvm.io",
        $cwd="",
        $creates="",
        $require=Package["curl"],
        $user=""){

    exec { $name:
        command => "curl -L ${site} | bash -s stable --ruby",
        #cwd => $cwd,
        #creates => "/home/kuhnen/.rvm",
        #require => $require,
        #unless => "! [ -d '/home/kuhnen/.rvm' ]",
        logoutput => true,

    }
}


exec {'oh-my-zsh':
  command => "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh",
  logoutput => true,
  require => Package['zsh'],
  #unless => ' ! [ -d "/home/kuhnen/.oh-my-zsh" ]',
}

exec {'echo "@terminator\n@skype\n@chromium-browser" >> /etc/xdg/lxsession/Lubuntu/autostart':

}

exec{'Sublime':
  command => 'curl -O http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2',
  cwd => '/home/kuhnen/Apps',
  require => File['/home/kuhnen/Apps'],
  unless => 'ls /home/kuhnen/Apps/Sublime Text 2',
  logoutput => true,
}

package { ["curl", 'scala', 'build-essential', 'terminator', 'vim', 'emacs', 'zsh']:
  ensure => latest,
}

file { ['/home/kuhnen/Apps', '/home/kuhnen/bin']:
  ensure => directory,
}

$monitor = $is_virtual ? {
  'true' =>  "#!/bin/bash
  xrandr --output VBOX1 --primary
  xrandr --output VBOX2 --right-of VBOX1
  xrandr --output VBOX1 --auto
  xrandr --output VBOX2 --auto",
  default =>
   "#!/bin/bash
  xrandr --output LVDS --primary
  xrandr --output VGA-0 --right-of LVDS
  xrandr --output VGA-0 --auto
  xrandr --output LVDS --auto
  ",

}

file{'/home/kuhnen/monitor_conf.sh':
  ensure => file,
  content => $monitor,

  owner => 'kuhnen',
  mode => 755,

  }

rvm_for {['kuhnen']: }
