define downloader ($download_url, $tarname, $extracted, $bin_dir = '', $binaries_to_copy = []) {
  include wget

  wget::fetch { $download_url:
    destination => $tarname
  }->
  exec { "exctract ${tarname}":
    command => "/bin/mkdir -p ${extracted} && /bin/tar -C ${extracted} --strip-components 1 -xzf ${tarname}",
    creates => $extracted,
  }

  if count($binaries_to_copy) > 0 {
    binary {$binaries_to_copy:
      bin_dir => $bin_dir,
      subscribe => Exec["exctract ${tarname}"]
    }
  }
}

define binary ($bin_dir) {
  file { "/usr/bin/${name}":
    ensure => file,
    source => "file:$bin_dir/${name}",
    #mode => "0777"
  }
}