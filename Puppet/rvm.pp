

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

package { ["curl", 'scala', 'build-essential']:
  ensure => latest,
}

file { ['/home/kuhnen/Apps', '/home/kuhnen/bin']:
  ensure => directory,

}

$monitor = $is_virtual ? {
  'true' => ['VBOX1', 'VBOX2'],
  default =>['LVDS', 'VGA-0'],
}

file{'/home/kuhnen/monitor_conf.sh':
  ensure => file,
  content =>

  "#!/bin/bash
  xrandr --output #{monitor[0]} --primary
  xrandr --output #{monitor[1]} --right-of #{monitor[0]}
  xrandr --output #{monitor[1]} --auto
  xrandr --output #{monitor[0]} --auto
  "
  owner => 'kuhnen',
  mode => 755,
  }

rvm_for {['kuhnen']: }
