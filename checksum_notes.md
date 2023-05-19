https://getfedora.org/en/security/

RPM files are signed by 'GPG signatures'; be sure to 'verify signatures'

Fedora provides 'current keys', for example:
Fedora 32
id:
4096R/12C944D0 2019-08-12
Fingerprint:
97A1 AE57 C3A2 372C CA3A 4ABA 6C13 026D 12C9 44D0


There a fedora GPG keys, which you import to GPG:
$ curl https://getfedora.org/static/fedora.gpg | gpg --import
This does:
gpg: key 6C13026D12C944D0: public key "Fedora (32) <fedora-32-primary@fedoraproject.org>" imported


Then there are also checksum files, which you can get on the page above, or here:
$ curl https://getfedora.org/static/fedora.gpg | gpg --import



This contains:
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

# Fedora-Workstation-Live-x86_64-32-1.6.iso: 1966178304 bytes
SHA256 (Fedora-Workstation-Live-x86_64-32-1.6.iso) = 4d0f6653e2e0860c99ffe0ef274a46d875fb85bd2a40cb896dce1ed013566924
-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJeoxq7AAoJEGwTAm0SyUTQ9U0P/0JsYUr02Z7A1nxs+lBTt78b
w6yxl95vl4NXtwnWH+jfWC9XZ7d8WKoeH6cXglcs3ecXbnpI5PV8xQ/w871bG/JH
1hK5fIEbx/Q80Dyoh5EdiuV+iYhKqI/qNSy2uNiFASgFR0SPTTs7aeuP3Exv4/vc
P4KK/bdBE3xmI7XXc5yqPJE8gn/YYcEdS7uQbgkQA3Vi5KjCwffnxtKc5Q+OzCAW
3QvMkr6GZNaIyH+hQdmtVEQVV8LUTxHCyy37kGAG29nLtZjwIX6tPjfSr8SbyRkn
7Ma7brm+uQ5zbP0VUhZA72GWuvC52OBCmoUyz1PNcKZgSp2KyEzbUtbJTljqfI9i
2c9Xgb/8tF4zU3D77B5SecCvKVbZW8KC1sOA3LA87mDQnyCIi4DgjU45NPutuS61
JrGuu19n5PAGzMJ3Ti6hmEviavd2QirLboGlrqVCvqH7JX+qSX4YuPcscaLCtAy5
aSzyro1EGYZFIdE6avV9KXoXCMn8br4YgzuEw4/Phvk6+KmEDZGMV4HILkKkrxvO
0ICShZr7wUA/NTslzyW2Bj9Nv2hQ5svcEpuZkci/Hf4XtxQg/UZj2UlRg8DyDcyY
fH754xkduzkzdX5PjPR5nmEs4p+ByGJfV/chnZuoIiVCXu7EHvjkfo9pyMPv4v8d
QkKm3TxTBBg+qg+rSkqC
=vWPF
-----END PGP SIGNATURE-----




You must 'verify the CHECKSUM file is valid" using:
$ gpg --verify-files *-CHECKSUM

This does:
gpg: Signature made Fri 24 Apr 2020 12:58:35 PM EDT
gpg:                using RSA key 6C13026D12C944D0
gpg: Good signature from "Fedora (32) <fedora-32-primary@fedoraproject.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 97A1 AE57 C3A2 372C CA3A  4ABA 6C13 026D 12C9 44D0

The "CHECKSUM file should have a good signature" from the fedora 32 KEY list above


Finally you check the trusted checksum matches the download:
$ sha256sum -c *-CHECKSUM

This does:
Fedora-Workstation-Live-x86_64-32-1.6.iso: OK
sha256sum: WARNING: 19 lines are improperly formatted

^This means the 'file is unmodified'
