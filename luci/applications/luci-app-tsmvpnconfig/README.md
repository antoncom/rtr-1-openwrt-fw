# VPNCONFIG LuCI module
Web UI for validating and save configuration data for number of VPN clients in UCI system.

# INSTALL
copy resources/* to /www/luci-static/resources/vpnconfig/ on target device.

copy luasrc/* to /usr/lib/lua/luci/ on target device.

# USAGE
If no configure found on target system, module will create empty file /etc/config/vpnconfig.

Valid fields of vpnconfig file sections are listed on *.htm pages.

Vpnconfig receives data from web UI, store it in UCI system and call run_backend_script() function. Real network configuration should be done inside run_backend_script().

# FILES UPLOAD
For IPSec configuration may be needed to upload files (certificates, public key). Server receives files througth POST request with action "upload_file" (client runs it on "Save" button click).

Server write files to /etc/config/vpnconfig_files with names "\<cfg section name\>_\<input filename\>". File names are stored in options of this section as well.

Plees, check that files exist before apply network configurations. Return 'false' if tey dont.
