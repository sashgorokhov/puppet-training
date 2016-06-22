stage { 'prepare':
  before => Stage['main'],
}

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
  refreshonly => true
}

file { '/etc/apt/sources.list.d/docker.list':
  ensure  => present,
}->
file_line { 'add docker repo':
  line    => 'deb https://apt.dockerproject.org/repo ubuntu-trusty main',
  path    => '/etc/apt/sources.list.d/docker.list',
}~>Exec['apt-get update']

file { '/etc/apt/apt.conf.d/local':
  ensure => present
}->
file_line { 'dpkg config':
  line    => 'Dpkg::Options {"--force-confdef";"--force-confold";}',
  path    => '/etc/apt/apt.conf.d/local',
}~>Exec['apt-get update']

exec { 'add docker keys':
  command => '/usr/bin/apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D',
  unless => '/usr/bin/apt-key list | /bin/grep -q docker',
}~>Exec['apt-get update']

file_line { 'alias kubectl-system':
  line => 'alias kubectl-system="kubectl --namespace=kube-system"',
  path => '/home/vagrant/.bashrc'
}

file_line { 'add master hostname':
  line => '127.0.0.1 master',
  path => '/etc/hosts'
}

$project_root = '/home/vagrant/kubernetes'
$downloads_dir = "${project_root}/downloads"
$releases_dir = "${project_root}/releases"

$kubernetes_url = 'https://github.com/kubernetes/kubernetes/releases/download/v1.3.0-beta.1/kubernetes.tar.gz'
$kubernetes_tar = "${downloads_dir}/kubernetes-v1.3.0-beta.1.tar.gz"
$kubernetes_release = "${releases_dir}/kubernetes-v1.3.0-beta.1"
$kubernetes_binaries_to_copy = ['hyperkube', 'kubectl']

file { $kubernetes_tar:
  ensure => file,
  replace => false,
  source => "${kubernetes_url}",
}~>
exec { 'extract kubernetes release':
  command => "/bin/tar -C ${kubernetes_tar} --strip-components 1 -xzf ${kubernetes_release}",
  creates => "${kubernetes_release}"
}~>
exec { 'extract kubernetes release binaries':
  command => "/bin/tar -C ${kubernetes_release} --strip-components 1 -xzf ${kubernetes_release}/server/kubernetes-server-linux-amd64.tar.gz",
  creates => "${kubernetes_release}/server/bin"
}

#$kubernetes_binaries_to_copy.each |String $binary| {
#  file { "/usr/bin/$binary":
#    ensure => file,
#    source => "file:${kubernetes_release}/server/bin/${binary}",
#    mode => "0777"
#  }
#}