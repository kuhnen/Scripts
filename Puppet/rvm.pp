

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

rvm_for {['kuhnen']: }
