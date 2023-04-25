

## Europratice Kits

To download files larger than 100 MB you have to use the Querio FTP server instead. You can login to the FTP server using the same user name and password used to login to Querio.

To access the files on the FTP server,


For security reasons, the FTP server will only accept encrypted connections. Therefore you have to configure your FTP client to use implicit SSL/TLS encryption.

The table below gives an overview of the FTP server settings that your FTP client requires in order to connect. Note that your FTP client may not need all of these settings to be explicitly defined. For example the port and transfer mode are usually automatically set by the FTP client.

| Server/host:         | data.europractice-ic.com       |
| :------------------- | ------------------------------ |
| Port:                | 990                            |
| User name:           | Same as your Querio user name. |
| Password:            | Same as your Querio password.  |
| Security/encryption: | SSL/TLS implicit               |
| Transfer mode:       | Passive                        |



The following transcript shows how to download:

```
[asiclab@penelope kits]$ sudo dnf install lftp
[asiclab@penelope kits]$ lftp ftps://data.europractice-ic.com
lftp data.europractice-ic.com:~> set ssl:verify-certificate no
lftp data.europractice-ic.com:~> login kennedycaisley
Password: 
lftp kennedycaisley@data.europractice-ic.com:~> pwd
ftps://kennedycaisley@data.europractice-ic.com
lftp kennedycaisley@data.europractice-ic.com:~> pwd
ftps://kennedycaisley@data.europractice-ic.com
lftp kennedycaisley@data.europractice-ic.com:~> ls
dr-x------   1 Querio Querio            0 Jul 28  2022 CERN
lftp kennedycaisley@data.europractice-ic.com:/> cd CERN/
lftp kennedycaisley@data.europractice-ic.com:/CERN> mirror TSMC28
```

As seen above, the easiest method to recursively download an entire directory is to have an identically named on on the local machine, and to use the `lftp ~> mirror <directory name>` command.

Also note that `set ssl:verify-certificate no` is unsecure, as it could allow for man in the middle attacks, but the better method [shown here](https://stackoverflow.com/questions/23900071/how-do-i-get-lftp-to-use-ssl-tls-security-mechanism-from-the-command-line#44095714) didn't work, and I'm not paid enough to figure out why.

### Joining the split .gz files:


```bash
cat HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz.* > HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz
```
