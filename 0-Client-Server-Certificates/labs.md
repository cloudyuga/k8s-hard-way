K8s hardway Meetup 
===============

## Self-signed CA
```
openssl genrsa -des3 -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
```
```
Country Name (2 letter code) []:IN
State or Province Name (full name) []:Karnataka
Locality Name (eg, city) []:Bangalore
Organization Name (eg, company) []: Meetup
Organizational Unit Name (eg, section) []:k8smeetup
Common Name (eg, fully qualified host name) []:cloudyuga.guru
Email Address []:neependra@cloudyuga.guru
```

## Create a Server certificate 

### Generate Private Key
```
openssl genrsa -out k8smeetup.com.key 2048
```

### Generate Certificate Signing Request 
```
openssl req -new -key k8smeetup.com.key -out k8smeetup.com.csr
```

```
Country Name (2 letter code) []:IN
State or Province Name (full name) []:Karnataka
Locality Name (eg, city) []:Bangalore
Organization Name (eg, company) []:k8smeetup
Organizational Unit Name (eg, section) []:Kubernetes The Hard Way
Common Name (eg, fully qualified host name) []: k8smeetup.com
Email Address []:neependra@cloudyuga.guru
```

### Look at the CSR request 
```
openssl req -in k8smeetup.com.csr -noout -text
```
```
Certificate Request:
    Data:
        Version: 0 (0x0)
        Subject: C=IN, ST=Karnataka, L=Bangalore, O=k8smeetup, OU=Kubernetes The Hard Way, CN= k8smeetup.com/emailAddress=neependra@cloudyuga.guru
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:bb:ea:5d:52:12:5a:15:c9:c4:50:03:97:23:d8:
                    12:4b:4a:56:61:9f:9d:6f:64:04:41:6b:dc:15:f6:
                    63:fc:8c:93:b9:42:60:8e:47:a2:09:77:58:54:a4:
                    17:0b:91:23:49:ad:9f:92:db:c1:e4:07:bf:bf:12:
                    c6:ba:4f:c1:28:3d:39:8a:96:cf:74:ae:48:5f:d3:
                    1b:af:eb:15:1b:cf:1d:9c:47:5b:9f:3e:38:be:d2:
                    50:f3:f0:89:d0:49:b6:52:6c:c2:3b:bc:6a:a5:44:
                    8d:cd:c3:07:1d:13:20:22:97:ff:a8:7b:b2:26:44:
                    fe:34:25:fe:f0:c3:bc:8c:7a:2f:37:ca:9a:0b:6a:
                    80:4c:84:b9:84:fd:b9:df:d1:f6:13:af:c9:18:ad:
                    ae:eb:ea:d7:e2:4d:00:c1:3d:39:42:d4:ac:78:77:
                    93:86:36:ba:43:24:c4:10:69:1f:85:37:4c:62:2d:
                    d7:36:48:b8:1a:bf:85:13:52:7d:90:be:79:9a:09:
                    fe:34:ab:8f:ba:59:b4:0f:b9:36:8b:da:1c:a1:71:
                    8c:6a:7d:70:ae:fe:e2:19:83:6a:fd:ee:0a:b0:f5:
                    4a:23:58:62:f8:0f:79:49:57:0a:ec:f7:56:91:ee:
                    9f:0e:f1:01:46:6e:f5:b3:b8:cc:c7:4b:65:38:37:
                    58:21
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha256WithRSAEncryption
         00:b5:05:0b:5f:d5:8f:78:17:49:8c:c1:15:7b:c7:e8:01:b0:
         e6:bb:d5:76:b0:4e:fa:4b:cc:b7:b6:96:9a:2a:93:dc:2b:25:
         51:db:8b:98:8f:dc:6b:cb:d9:e3:78:2b:47:97:3c:ba:44:9d:
         e3:f5:7e:06:cb:19:1a:ce:d5:eb:0b:a1:eb:92:13:64:c4:05:
         19:7b:b7:7a:e5:2f:81:e6:5c:3e:8d:b8:2b:ce:3b:16:58:36:
         45:c2:05:8e:46:de:36:fd:ac:c8:44:87:59:63:dc:50:4f:9b:
         53:c1:47:6a:7a:bf:76:c5:65:15:3e:b9:62:3f:84:a2:ec:83:
         8e:82:de:77:8a:fd:63:80:0a:0e:c7:91:2f:58:36:b2:b9:8b:
         ea:3b:3d:fb:cb:b9:30:11:fb:59:ec:da:26:3b:be:56:04:22:
         28:ee:f8:c8:e5:f2:f7:97:2d:72:43:15:de:b6:03:f5:c0:ec:
         00:ad:93:7a:40:6a:ff:0f:c1:5a:c3:76:b5:49:9c:59:d5:31:
         e0:05:5b:13:dd:92:f7:e9:eb:44:21:7a:73:72:91:54:0d:b0:
         25:bf:35:b7:94:39:aa:f7:4d:a1:f0:af:9d:16:b5:7a:b3:28:
         ca:5b:9e:12:75:2b:76:8d:ee:fa:4b:1d:d3:53:a7:2f:e2:48:
         a1:4a:48:bc
```

### Generate the Certificate
```
openssl x509 -req -in k8smeetup.com.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out k8smeetup.com.crt -days 500 -sha256
```

### Look at the Certificate 
```
openssl x509 -in k8smeetup.com.crt -text -noout
```

```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 9232626075319313703 (0x8020e07fbb6aa527)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=IN, ST=Karnataka, L=Bangalore, O=Meetup, OU=k8smeetup, CN=cloudyuga.guru/emailAddress=neependra@cloudyuga.guru
        Validity
            Not Before: Dec 22 06:18:09 2018 GMT
            Not After : May  5 06:18:09 2020 GMT
        Subject: C=IN, ST=Karnataka, L=Bangalore, O=k8smeetup, OU=Kubernetes The Hard Way, CN= k8smeetup.com/emailAddress=neependra@cloudyuga.guru
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:bb:ea:5d:52:12:5a:15:c9:c4:50:03:97:23:d8:
                    12:4b:4a:56:61:9f:9d:6f:64:04:41:6b:dc:15:f6:
                    63:fc:8c:93:b9:42:60:8e:47:a2:09:77:58:54:a4:
                    17:0b:91:23:49:ad:9f:92:db:c1:e4:07:bf:bf:12:
                    c6:ba:4f:c1:28:3d:39:8a:96:cf:74:ae:48:5f:d3:
                    1b:af:eb:15:1b:cf:1d:9c:47:5b:9f:3e:38:be:d2:
                    50:f3:f0:89:d0:49:b6:52:6c:c2:3b:bc:6a:a5:44:
                    8d:cd:c3:07:1d:13:20:22:97:ff:a8:7b:b2:26:44:
                    fe:34:25:fe:f0:c3:bc:8c:7a:2f:37:ca:9a:0b:6a:
                    80:4c:84:b9:84:fd:b9:df:d1:f6:13:af:c9:18:ad:
                    ae:eb:ea:d7:e2:4d:00:c1:3d:39:42:d4:ac:78:77:
                    93:86:36:ba:43:24:c4:10:69:1f:85:37:4c:62:2d:
                    d7:36:48:b8:1a:bf:85:13:52:7d:90:be:79:9a:09:
                    fe:34:ab:8f:ba:59:b4:0f:b9:36:8b:da:1c:a1:71:
                    8c:6a:7d:70:ae:fe:e2:19:83:6a:fd:ee:0a:b0:f5:
                    4a:23:58:62:f8:0f:79:49:57:0a:ec:f7:56:91:ee:
                    9f:0e:f1:01:46:6e:f5:b3:b8:cc:c7:4b:65:38:37:
                    58:21
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
         7d:e8:32:33:63:11:7a:23:9f:b2:4f:6b:55:7d:f2:d2:14:47:
         89:76:2b:74:04:2e:70:88:3d:74:05:3e:26:19:f0:94:94:ba:
         c8:7c:28:14:0e:79:5d:90:b3:c7:c1:b4:21:73:0e:5e:5a:8a:
         15:34:1e:9f:9c:86:62:71:2f:29:fa:1f:df:4c:58:bf:5e:08:
         ac:48:bb:08:c4:7e:ce:7a:19:0b:25:e4:6a:cd:94:40:f5:9f:
         0c:ae:b6:cd:fd:f6:f4:9e:5a:9a:e8:f1:09:14:bd:58:18:b0:
         45:88:62:45:92:bf:51:95:56:4c:d3:91:f4:5e:35:41:35:84:
         d4:5e:71:08:85:b7:f2:c3:a4:3a:a5:80:e3:20:ee:49:cf:45:
         37:ef:7a:bb:60:0a:30:dc:97:56:a2:46:28:32:46:8a:93:a8:
         37:89:68:05:6b:b3:1a:a9:61:43:f5:dc:7f:13:ff:b0:29:00:
         ec:3f:9f:5b:38:ab:06:b0:31:f6:b7:e9:a2:7b:bb:31:33:1e:
         a4:a2:a9:9c:aa:50:d4:44:d4:dc:35:50:f9:b5:12:94:ff:b8:
         6a:b5:1c:0d:ce:2e:f8:34:eb:47:0f:53:90:b4:0b:04:65:30:
         3f:1f:9a:d5:34:30:29:d9:52:09:a3:dd:94:55:58:c7:dd:77:
         01:81:10:02:65:de:5d:66:9c:ff:3b:9f:a6:b4:af:7a:39:e5:
         9a:98:af:15:3f:5a:53:5c:10:19:ba:b8:12:25:b0:d8:45:9d:
         bb:3b:2e:38:66:d0:a3:d3:e4:dd:a3:9f:03:52:6f:e7:a5:55:
         dc:3d:10:6b:55:83:0e:97:85:c3:79:6d:46:7e:ec:97:a2:9f:
         7c:33:23:16:d5:aa:d0:2c:da:2d:c6:81:9c:43:6a:22:a6:56:
         be:4f:39:fa:9d:0b:a7:50:c6:91:6c:25:48:a2:8f:ac:ba:7a:
         34:09:e3:7d:4b:d3:1a:cf:30:07:6f:50:b0:b2:bc:2b:0b:4d:
         81:26:c6:7f:88:a2:2c:32:be:55:e5:e1:e0:f5:09:bd:a2:3e:
         52:95:33:ee:1f:03:9d:f6:68:b5:e7:3f:46:99:83:09:e1:54:
         8d:77:2e:88:f0:26:71:8b:eb:79:ed:f6:55:66:4c:a1:5b:34:
         12:56:ad:64:c8:ef:43:80:65:5e:fe:98:de:6f:4d:85:63:af:
         39:d7:a3:4d:42:fa:58:8b:e0:ae:dc:88:fb:15:6c:b7:dd:df:
         84:e3:dc:95:9e:10:57:35:37:26:66:72:69:42:f1:6b:d7:6e:
         76:c1:ba:2d:1c:53:09:e6:30:d3:4b:78:f4:4e:71:b7:ad:38:
         56:d7:2d:57:47:6b:a4:ed
```


## Create a Client certificate 

### Generate Private Key
```
openssl genrsa -out client.key 2048
```

### Generate Certificate Signing Request 
```
openssl req -new -key client.key -out client.csr
```
```
Country Name (2 letter code) []:IN
State or Province Name (full name) []:Karnataka
Locality Name (eg, city) []:Bangalore
Organization Name (eg, company) []:Meetup
Organizational Unit Name (eg, section) []:k8smeetup
Common Name (eg, fully qualified host name) []:192.168.2.3
Email Address []:neependra@cloudyuga.guru
```

### Look at the CSR request 
```
openssl req -in client.csr -noout -text
```

```
Certificate Request:
    Data:
        Version: 0 (0x0)
        Subject: C=IN, ST=Karnataka, L=Bangalore, O=Meetup, OU=k8smeetup, CN=192.168.2.3/emailAddress=neependra@cloudyuga.guru
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:d4:ec:b0:ad:d0:64:33:22:53:d8:5e:ff:bc:43:
                    7a:47:94:04:d0:dc:38:e8:73:c7:89:60:c8:06:d1:
                    79:ed:93:8f:7c:13:28:30:e3:a8:bb:bf:02:35:2c:
                    28:79:e0:ba:64:21:a7:6b:6d:d3:55:53:d5:21:45:
                    1c:d8:7b:44:f9:30:75:24:c5:dd:d6:f0:72:d9:5c:
                    bf:32:3e:70:0a:83:5b:09:f2:97:90:f2:25:22:12:
                    fd:6c:de:63:0f:1a:4d:f9:e2:ba:2f:5d:e8:7d:70:
                    ba:8d:c1:72:c2:15:4e:8b:ef:92:fc:25:31:1a:28:
                    69:6f:d7:51:a2:4c:7f:c7:8b:20:0d:11:ff:0e:58:
                    73:1b:2a:d0:62:d6:5c:39:a8:3a:c6:03:08:84:d6:
                    1c:8d:34:98:97:d7:82:fa:fa:6e:99:02:11:2a:5d:
                    5e:34:11:4e:c2:56:c0:c4:81:b0:24:93:9d:12:af:
                    5f:44:3b:1b:98:86:30:34:87:e6:dc:be:0f:35:e7:
                    74:f7:ee:de:b6:7d:15:de:7b:9b:d3:40:a6:c3:c6:
                    3c:ca:79:59:1b:e9:6a:b4:af:71:81:7e:9d:0d:26:
                    53:b8:fb:2f:a9:5f:65:90:55:17:07:c8:79:f2:9c:
                    84:2e:4c:0d:06:34:1a:59:72:71:c7:9d:82:bf:12:
                    52:e7
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha256WithRSAEncryption
         83:d7:9f:a1:7f:26:66:d4:0f:c5:25:94:90:f7:f3:62:d8:07:
         2f:a0:c6:a2:1e:16:1c:bf:42:12:ed:d6:2f:3f:87:12:d2:81:
         e3:63:71:e4:3c:db:32:97:79:e1:48:fc:5e:09:d3:bb:33:c5:
         50:98:1f:03:1f:02:ca:7c:f1:99:b2:9a:ca:7b:57:5b:f4:5c:
         c1:f9:c7:e6:e3:cf:d4:5d:75:7f:4e:d8:34:7a:9b:53:1d:08:
         c4:0d:4c:5d:84:fa:97:fb:fb:64:0e:6b:98:ed:55:7e:5f:52:
         13:47:61:9c:15:9b:a7:02:24:e4:25:3f:33:2d:a4:53:a7:9b:
         2a:09:39:b8:c6:e7:ef:a3:ad:89:00:e5:3a:27:a9:3d:26:f2:
         37:9f:e6:c7:de:d0:b4:6d:d5:8e:4d:83:bb:51:b1:e6:d7:85:
         c9:7e:64:92:5f:2e:db:06:46:24:66:2a:b2:3d:aa:7c:42:2e:
         13:ec:d6:92:30:a5:18:67:c8:fc:24:2b:f3:4c:1a:28:9c:ea:
         6d:9b:8e:e4:15:3a:81:c5:39:6a:a6:40:69:da:eb:d8:44:b1:
         21:46:4e:ea:4b:a5:83:e0:9f:e0:1d:c7:1c:46:38:b6:4c:fb:
         0c:72:13:ae:e0:cb:9e:55:a8:c9:9f:ac:91:b0:2b:50:3f:be:
         e0:a0:5f:7b
```

### Generate the Certificate
```
openssl x509 -req -in client.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out client.crt -days 500 -sha256
```

### Look at the Certificate 
```
openssl x509 -in client.crt -text -noout

```
```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 9232626075319313704 (0x8020e07fbb6aa528)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=IN, ST=Karnataka, L=Bangalore, O=Meetup, OU=k8smeetup, CN=cloudyuga.guru/emailAddress=neependra@cloudyuga.guru
        Validity
            Not Before: Dec 22 06:27:30 2018 GMT
            Not After : May  5 06:27:30 2020 GMT
        Subject: C=IN, ST=Karnataka, L=Bangalore, O=Meetup, OU=k8smeetup, CN=192.168.2.3/emailAddress=neependra@cloudyuga.guru
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:d4:ec:b0:ad:d0:64:33:22:53:d8:5e:ff:bc:43:
                    7a:47:94:04:d0:dc:38:e8:73:c7:89:60:c8:06:d1:
                    79:ed:93:8f:7c:13:28:30:e3:a8:bb:bf:02:35:2c:
                    28:79:e0:ba:64:21:a7:6b:6d:d3:55:53:d5:21:45:
                    1c:d8:7b:44:f9:30:75:24:c5:dd:d6:f0:72:d9:5c:
                    bf:32:3e:70:0a:83:5b:09:f2:97:90:f2:25:22:12:
                    fd:6c:de:63:0f:1a:4d:f9:e2:ba:2f:5d:e8:7d:70:
                    ba:8d:c1:72:c2:15:4e:8b:ef:92:fc:25:31:1a:28:
                    69:6f:d7:51:a2:4c:7f:c7:8b:20:0d:11:ff:0e:58:
                    73:1b:2a:d0:62:d6:5c:39:a8:3a:c6:03:08:84:d6:
                    1c:8d:34:98:97:d7:82:fa:fa:6e:99:02:11:2a:5d:
                    5e:34:11:4e:c2:56:c0:c4:81:b0:24:93:9d:12:af:
                    5f:44:3b:1b:98:86:30:34:87:e6:dc:be:0f:35:e7:
                    74:f7:ee:de:b6:7d:15:de:7b:9b:d3:40:a6:c3:c6:
                    3c:ca:79:59:1b:e9:6a:b4:af:71:81:7e:9d:0d:26:
                    53:b8:fb:2f:a9:5f:65:90:55:17:07:c8:79:f2:9c:
                    84:2e:4c:0d:06:34:1a:59:72:71:c7:9d:82:bf:12:
                    52:e7
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
         17:da:99:ff:a1:ca:fc:18:1f:50:ad:fb:48:35:a1:2d:55:8f:
         e4:66:40:2a:20:bb:b1:58:f5:e4:71:dc:0c:c7:2d:15:c0:83:
         30:7a:2d:59:7a:37:52:d2:cf:42:03:1c:5a:34:9d:7c:d3:b5:
         1e:f5:d0:2a:db:ff:91:6a:a4:cb:fb:c0:8a:f1:82:d0:aa:a2:
         fa:63:a4:58:69:23:9c:45:90:4a:a0:d2:34:f5:05:c6:05:b7:
         ff:5f:5e:1f:23:b0:6f:af:1a:a3:74:d0:f3:58:1f:c2:55:e4:
         0d:d0:d7:fa:14:59:f6:82:1a:ca:9c:f4:a7:e1:a1:cb:8a:44:
         05:f4:03:0d:25:13:6e:40:ae:11:0a:67:65:7d:8e:48:ed:78:
         f2:2c:bb:7f:61:59:2e:83:fc:3b:27:1c:34:92:ca:9e:97:20:
         0a:e5:3c:32:ce:f6:b3:cc:1e:d0:61:83:f6:e0:3c:bf:82:df:
         40:62:71:9d:65:30:4b:53:39:c3:90:73:88:76:8a:ea:dc:0a:
         2c:36:1c:a6:61:82:cd:f8:3d:21:5a:c5:78:17:11:20:e0:f2:
         32:ed:52:6a:40:bd:66:7d:1d:8f:c9:cd:16:88:8b:15:93:4d:
         f8:52:72:9c:d0:a2:e4:7f:5e:a2:a5:41:f0:35:7a:7e:77:02:
         78:39:e0:22:89:d9:97:3c:6d:1f:15:23:68:36:a8:ed:8c:6b:
         61:ac:ca:86:76:8b:1a:da:ff:3e:6e:53:66:0d:6d:3b:27:ec:
         c4:71:27:ad:1e:ff:da:18:09:3c:41:16:78:c6:31:f9:99:ad:
         c3:ff:a3:2a:3e:3d:8f:c1:2a:05:7d:de:50:1f:e0:45:38:fd:
         4a:f5:91:62:96:53:91:e6:4b:68:1e:45:47:35:c0:34:5f:54:
         56:d2:f6:21:3c:e0:bb:11:0e:ff:82:9b:66:57:98:25:52:8f:
         80:a8:b8:a5:8b:69:16:7e:af:96:ef:b4:f4:f9:30:0c:3b:d1:
         29:56:f6:e4:c6:19:1d:d4:76:e0:53:8d:d1:20:0c:f3:41:01:
         8c:25:f4:6f:14:a0:1b:ee:0b:4b:63:d8:e4:99:f4:74:81:9c:
         91:38:ad:ce:9f:c7:8e:7f:5a:0a:5f:8b:c6:51:f2:55:06:1e:
         2a:96:9d:2b:70:73:35:07:23:c9:ed:ad:bf:54:40:44:67:72:
         7d:28:5d:c8:31:3c:67:23:91:8c:a6:fb:06:ff:54:8a:54:7a:
         da:ba:a8:49:9d:f7:2c:94:d7:00:6a:aa:74:ef:e9:fc:24:8d:
         ae:2a:43:f1:b6:e0:ed:bc:39:c2:ed:29:b9:97:b5:5f:67:e8:
         e1:e3:49:22:16:cf:bc:d8
         
```



