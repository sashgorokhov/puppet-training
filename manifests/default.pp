
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

file_line { 'add hostname':
  line => "${master_ip} master",
  path => '/etc/hosts'
}

downloader {'get kubernetes':
  download_url => $kubernetes_url,
  tarname => $kubernetes_tarname,
  extracted => $kubernetes_release
}~>
exec { 'extract kubernetes release binaries':
  command => "/bin/tar -C ${kubernetes_release} --strip-components 1 -xzf ${kubernetes_release}/server/kubernetes-server-linux-amd64.tar.gz",
  creates => $kubernetes_bin_dir
}->
binary {['hyperkube', 'kubectl']:
  bin_dir => $kubernetes_bin_dir
}

downloader {'get etcd':
  download_url => $etcd_url,
  tarname => $etcd_tarname,
  extracted => $etcd_release,
  bin_dir => $etcd_release,
  binaries_to_copy => ['etcd', 'etcdctl']
}

downloader {'get flannel':
  download_url => $flannel_url,
  tarname => $flannel_tarname,
  extracted => $flannel_release,
  bin_dir => $flannel_release,
  binaries_to_copy => ['flanneld']
}

downloader {'get heapser':
  download_url => $heapster_url,
  tarname => $heapster_tarname,
  extracted => $heapster_release,
}

