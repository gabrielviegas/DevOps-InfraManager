provider "virtualbox" {}

resource "virtualbox_vm" "vm1" {
  name   = "vm1"
  image  = "ubuntu/bionic64"
  cpus   = 2
  memory = "1024"
}
