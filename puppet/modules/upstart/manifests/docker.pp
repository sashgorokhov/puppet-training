
class upstart::docker {
  file {'set /etc/default/docker':
    name => 'set /etc/default/docker',
    path => '/etc/default/docker',
    ensure => file,
    source => 'puppet:///modules/upstart/docker'
  }
}