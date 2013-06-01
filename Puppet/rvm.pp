

Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
define rvm_for(
        $site="https://get.rvm.io",
        $cwd="",
        $creates="",
        $require=Package["curl"],
        $user=""){

    exec { $name:
        command => "curl -L ${site} | bash -s stable --ruby",
        cwd => $cwd,
        creates => "/home/${name}/.rvm",
        require => $require,
        logoutput => true,
    }
}

package { ["curl", 'scala', 'build-essential', 'terminator']:
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
