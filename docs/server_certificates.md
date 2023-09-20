# Server certificates
The HRZ offers SSL certificates which can be used to authenticate a server. They can be requested [here [1]](https://www.hrz.uni-bonn.de/en/all-services/administrator-tools/certificates?set_language=en). These certificates are vaild for 12 months and you will receive a notification email a few weeks before they expire.

General procedure:
- Generate a private/public key pair
- Fill the certificate request form and attach the public key
- HRZ issues a server certificate and a CA (trust chain) file
- Copy the certificates to the server and add them to the httpd and ssl config files

# Create a key pair
Suggested method taken from [[1]](https://www.hrz.uni-bonn.de/en/all-services/administrator-tools/certificates?set_language=en). Replace the servername and email fields with the server hostname and the admin email address.
```
openssl req -nodes -newkey rsa:4096 -keyout server.key -keyform PEM \
-out server.req -outform PEM -sha256 -subj \
"/C=DE/ST=Nordrhein-Westfalen/L=Bonn/O=Rheinische \
Friedrich-Wilhelms-Universitaet \
Bonn/CN=servename.uni-bonn.de/emailAddress=uni-id@uni-bonn.de"
```
The public key (server.req) is the one you send to HRZ to be signed. It is not needed anymore after this has been done.

The private key (server.key) remains on the server and should never be copied anywhere else. You can create a copy of this private key without password with `openssl rsa -in server.key -out server-no-pw.key`. Later during service configuration, the private key will be referenced.

# Configure the server
HRZ offers several files for download after the request has been processed. They differ in encoding formats etc. Pick one of the server certificate files and one CA certificate file and copy them to the server.

The actual server configuration may vary. Silab-redmine requires modifications in /etc/httpd/conf.d/ssl.conf and /etc/httpd/conf/httpd.conf. In both files, find the relevant keywords and point to the files you received from HRZ.
- `SSLCertificateFile` is the "PEM-encoded certificate-only" server certificate file, e.g. *silab-redmine_physik_uni-bonn_de_cert.cer*
- `SSLCACertificateFile` is the "PEM-encoded Root/Intermediate(s) only" trust chain file e.g. *silab-redmine_physik_uni-bonn_de_interm.cer*
- `SSLCertificateKeyFile` points to the server private key. It may be necessary  to use the "no-pw" variant of this file

> It may be necessary to update the trusted chain on the server. For silab-redmine, copy the [SSLCACertificateFile] to `/etc/pki/ca-trust/source/anchors/`, run `update-ca-trust extract` and copy the extracted file to the expected location: `cp /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/pki/tls/certs/silab-redmine-ca-bundle.crt`.

Restart the web server: `service httpd restart`, reload the website and verify the certificate in your browser.
