/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "network_storage" {
  description = "Describes a filestore instance."
  value = {
    server_ip     = google_filestore_instance.filestore_instance.networks[0].ip_addresses[0]
    remote_mount  = google_filestore_instance.filestore_instance.file_shares[0].name
    local_mount   = var.local_mount
    fs_type       = "nfs"
    mount_options = "defaults,_netdev"
  }
}

output "install_nfs_client" {
  description = "Script for installing NFS client"
  value       = file("${path.module}/scripts/install-nfs-client.sh")
}

output "install_nfs_client_runner" {
  description = "Runner to install NFS client using the startup-script module"
  value       = local.install_nfs_client_runner
}

output "mount_runner" {
  description = <<-EOT
  Runner to mount the file-system using the startup-script module.
  This runner requires ansible to be installed. This can be achieved using the
  install_ansible.sh script as a prior runner in the startup-script module:
  runners:
  - type: shell
    source: modules/startup-script/examples/install_ansible.sh
    destination: install_ansible.sh
  - $(your-fs-id.mount_runner)
  ...
  EOT
  value       = local.mount_runner
}
