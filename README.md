# spacewalk
Vagrantfile for spacewalk server and 2 clients.

## server
* Server needs 4G of ram.
* Added a 100GB disk and mounted it at `/var/satellite/redhat`
  * This made SELinux angry. Kept getting [Errno 14] PYCURL ERROR 22 - "The requested URL returned error: 404 Not Found"
  *  `semanage fcontext -a -t spacewalk_data_t "/var/satellite/redhat(/.*)?"`
  * `restorecon -R -v /var/satellite/redhat`
