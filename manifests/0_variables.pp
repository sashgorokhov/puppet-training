$master_ip = '192.168.50.50'

$project_root = '/home/vagrant/kubernetes'
$downloads_dir = "${project_root}/downloads"
$releases_dir = "${project_root}/releases"

$kubernetes_url = 'https://github.com/kubernetes/kubernetes/releases/download/v1.3.0-beta.1/kubernetes.tar.gz'
$kubernetes_tarname = "${downloads_dir}/kubernetes-v1.3.0-beta.1.tar.gz"
$kubernetes_release = "${releases_dir}/kubernetes-v1.3.0-beta.1"
$kubernetes_bin_dir = "${kubernetes_release}/server/bin"

$etcd_url = 'https://github.com/coreos/etcd/releases/download/v2.3.6/etcd-v2.3.6-linux-amd64.tar.gz'
$etcd_tarname = "${downloads_dir}/etcd-v2.3.6-linux-amd64.tar.gz"
$etcd_release = "${releases_dir}/etcd-v2.3.6-linux-amd64"

$flannel_url = 'https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz'
$flannel_tarname = "${downloads_dir}/flannel-0.5.5-linux-amd64.tar.gz"
$flannel_release = "${releases_dir}/flannel-0.5.5-linux-amd64"

$heapster_url = 'https://github.com/kubernetes/heapster/archive/v1.1.0.tar.gz'
$heapster_tarname = "${downloads_dir}/heapster-v1.1.0.tar.gz"
$heapster_release = "${releases_dir}/heapster-v1.1.0"
