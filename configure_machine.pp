#include archive
Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
$user_dir = "/home/$id"
$dirToApps = "$user_dir/puppet_test"
notice("Apps path: $dirToApps")
notice("User is: $id")
$sublime = 'Sublime%20Text%202.0.1%20x64.tar.bz2'
$rvmSite = "https://get.rvm.io"

exec { "DownloadSublime":
  cwd => "$dirToApps",
  command => "curl -O http://c758482.r82.cf2.rackcdn.com/$sublime",
  creates => "$dirToApps/Sublime Text 2",
}

exec { 'rvm':
  cwd => $user_dir,
  command => "sudo $id curl -L ${rvmSite} | bash -s stable --ruby",
  logoutput => true,
  creates => "$user_dir/.rvm",
}

exec { 'UntarSublime':
  cwd => $dirToApps,
  command => "tar -xjvf $sublime",
  creates => ["$dirToApps/Sublime Text 2"],
}

exec { 'RemoveSublime':
  cwd => $dirToApps,
  command => "rm $sublime",
  onlyif => "test -f $sublime",

}



exec { "deb http://download.virtualbox.org/virtualbox/debian raring contrib >> /etc/apt/sources.list":
  cwd => $user_dir,
  creates => "$user_dir/oracle_vbox_asc",
} ->

exec { "wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -":
  cwd => $user_dir,
} ->
package { "update":
  ensure => latest,
} ->
package { "virtualbox":
  ensure => latest,
}

file { [$dirToApps, '/home/kuhnen/bin']:
  ensure => directory,
}


exec {'oh-my-zsh':
  command => "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh",
  logoutput => true,
  creates => "$user_dir/.oh-my-zsh",
  require => Package['zsh'],
}


exec { "git clone git@github.com:kuhnen/Scripts.git":
  creates => "$user_dir/Git",
  logoutput => true,

}

file { "$user_dir/Bitbucket":
  ensure => present,
}

exec { "dropbox":
  cwd => $user_dir,
  command => "curl -O - https://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -",
  creates => "$user_dir/.dropbox-dist",
}


package { ["curl", 'scala', 'build-essential', 'terminator', 'vim', 'emacs',
 'zsh','erl', 'git', 'ssh']:
  ensure => latest,
}


File[$dirToApps] -> Package['curl'] ->
 Exec['DownloadSublime', 'oh-my-zsh', 'rvm'] -> Exec['UntarSublime'] -> Exec['RemoveSublime']

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

exec {'echo "@terminator\n@skype\n@chromium-browser" >> /etc/xdg/lxsession/Lubuntu/autostart':
  creates => "$user_dir/.autostart_created",
}

exec {'git clone git@github.com:xinmingyao/erlang-ide-emacs.git':
  cwd => $dirToApps,
  require => Package['git', 'ssh'],
}

file { "$user_dir/.ssh/id_rsa":
  ensure => present,
  content => $rsaPrivateKey,
  require => Package['ssh']

}


file { "$user_dir/.ssh/id_rsa.pub":
  ensure => present,
  content => $rsaPublicKey,
  require => Package['ssh'],
}

file {"$user_dir/.gitignore":
  ensure => present,
  content => $gitignore
  }


$gitignore = "# Compiled source #
###################
*.com
*.class
*.dll
*.exe
*.o
*.so

# Packages #
############
# it's better to unpack these files and commit the raw source
# git has its own built in compression methods
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Logs and databases #
######################
*.log
*.sql
*.sqlite

# OS generated files #
######################
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
Icon?
ehthumbs.db
Thumbs.db

# sbt specific
dist/*
target/
lib_managed/
src_managed/
project/boot/
project/plugins/project/

# Scala-IDE specific
.scala_dependencies"

$rsaPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKfOyPC1DOFrKVDAY+A+QyAG7LetU+I93lgelabsmIG77fwGj9bZ2cTcoh3IcEYelRDpOO0ivn9Oo3MhOAX6F/XlAKkAViJR3j4XqQ6gQspD9ONvEAtMqhrAMp5wSI6nRv4pILOipzM0+BzBKE/N+cyzPnBDB/6ipkhM0CrCTcie3/Ve4tnMUCgBe7sokEqNSue+RJWaHZwLr6AqJHHvTFdnmJ/JEAJ0cWsN7lXWZ60JQkdAvkQpZ/VyrdFWyF0wg5+NHX09gkWuCLjgxRjkPUwOIP647aSik9USp+/uTmCgEwyl5Diw9vf3hHgTevGNFzIqY3mm/T/q5SAvyE7k8R andrekuhnen@gmail.com"

$rsaPrivateKey = "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAynzsjwtQzhaylQwGPgPkMgBuy3rVPiPd5YHpWm7JiBu+38Bo
/W2dnE3KIdyHBGHpUQ6TjtIr5/TqNzITgF+hf15QCpAFYiUd4+F6kOoELKQ/Tjbx
ALTKoawDKecEiOp0b+KSCzoqczNPgcwShPzfnMsz5wQwf+oqZITNAqwk3Int/1Xu
LZzFAoAXu7KJBKjUrnvkSVmh2cC6+gKiRx70xXZ5ifyRACdHFrDe5V1metCUJHQL
5EKWf1cq3RVshdMIOfjR19PYJFrgi44MUY5D1MDiD+uO2kopPVEqfv7k5goBMMpe
Q4sPb394R4E3rxjRcyKmN5pv0/6uUgL8hO5PEQIDAQABAoIBAQCnHg17TaKGRPNk
0gTA4CNRJUxMAffHDoEP73VxnqgT/po9PycnqnV/UDB4W/LPKiQPMxGTuWBlU5yO
q3Su6b53SZaT8SOQSgPuVOT8fzesxG4/Flc39v6aCkaeKb1zZtVsljlkrL/mTj3b
aVsLiUzgslEG5E1G9TPBvF0bTIorvO3PVtc3sQW6Y1y53lb5kRrWVmCY7+vH92X1
IEYzI8iRs7zAM+1R99nEKo8sEbv5sr61xw8iiUWxpsSh1PKVF0BD+io1XQRbRoIq
kUocvybDapYoIlRmwb016fSYdOGgEv/3h4uyQnLGKoj/zB5UXn62OAAgqhUF8mwz
/2/8vt7VAoGBAPYAhxBsm4I5X2O8+bIte24TcYCP+2C746Bu9SoCwwyJ7XbQHKXH
7Ds7zFZy3jQEPfKOP9An1SeShVYa4KbFXTCMPb05WaCbpS1ovu3JgpHBfDQ8ykDG
ZWLQ7IbMQHjVU75CpFDmsENDyTL8i3bbbTQkV9bedXiEKiucn7CFffkLAoGBANK3
qgbxMwaYTC3qGa0I8GkEb/pJciXzOn/Ic7MjWzZ5qIempqhA94Nj3f/78R+eif8S
84P6ET53AU+DmJfLdeDwnpBOpVXY3NzceH5oC4cM1tueA8YNdzUqmFIcHtiPBY6T
CEpXxB38diq9TDugGeCdxHYhEBOLLw5FgLxfAwHTAoGBANmH3edIIrskwJURpjtI
vLy5tMRajY8clkxn0aM0jgWocbN+k9aE0wAOAMLxEEwu9BhocUU/89zqU72wRrcy
DxW+7VlGPVsoRwfAeBUM+8inr40BtFdTGJQo6v7H3rr66PJ1O5fOZk8UwfW0HB8e
KZLSEFqQnI/VTvUBqrQNVzfBAoGAHE3FTedqJjGg0e4HAuIXgNOywtjIt2ZDblSb
je1q3BddVtNAwYrwdDqe4DqUOd4OxS9jfE/DrzNG/so7XfBbZhqMAfA+bxiRGi2X
Fcud+Mb1uUwxT5IReBe/nA/g6M/VPEBttaayViDKMpV4vu2TbENk10U7ppRkfrNB
RowwmDcCgYAPf5LWiINyxkohlobLD1uZo7WtrHQMN3pil9PHIMJ03DDXZ26eG9YE
dHkdYl/mT/e3UmCvMhnzil3uOYVQCyT1HbTXm8squIlE5TwMip63XuBbGl7log3m
0oHs+16hnIyCdu/mH1M/41urVriPSOMGSGvc5P1Qel4i9N1aHYQ7jw==
-----END RSA PRIVATE KEY-----
"
