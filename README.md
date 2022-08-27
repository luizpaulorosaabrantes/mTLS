# mTLS
Repository to mTLS tests

This repo is divide into `client` and `server` sides (folder). On client side we got the `nginx` as a gateway, and on server we got the `nginx` as reverse proxy.

## Client
Configured `nginx` app to "encode" a normal http request to a https mTLS request.

On client folder we have got this files:
* `Dockerfile` image deviated from nginx with act as a gateway. 
* `nginx.con` configuration for nginx app.

## Server
Configured `nginx` app to "decode" a https mTLS request to another app (we're gonna use [http.bin](https://httpbin.org/)) which listen a normal http protocol.

On server folder we have got this files:
* `Dockerfile` image deviated from nginx with act as a reverse proxy. 
* `nginx.con` configuration for nginx app.

## Docker compose

The [docker-compose file](docker-compose.yaml) contains three microservice, `mtls-server` contains the reverse proxy with "decode"  the mtls, `mtls-clinet` as a gateway (mTls "encode") and httpin serving as example.

```yaml
services:
  # mTLS server side
  mtls-server:
    ...
    ports:
      - 443:443

  # mTLS server side
  mtls-client:
    ...
    ports:
      - 9090:80 

  # Application to expose http
  httpbin:
    ...
    ports:
      - 8000:80  
```

## Certificates

To run this tests we must have the certificates. The following procedure create those certs, the folder `cert` already has the example certificates.

Setup names and files
```sh
export CA_FILE=ca.crt
export KEY_FILE=ca.key
export SUBJECT='/C=BR/ST=State/L=Local/O=Something inc/CN=localhost'

export CLIENT_BASE_NAME=client
export CSR_FILE=${CLIENT_BASE_NAME}.csr
export CLIENT_KEY_FILE=${CLIENT_BASE_NAME}.key
export CLIENT_SUBJECT="/CN=${CLIENT_BASE_NAME}"
export CLIENT_CRT_FILE=${CLIENT_BASE_NAME}.crt
export CLIENT_P12_FILE=${CLIENT_BASE_NAME}.p12
export CLIENT_PFX_FILE=${CLIENT_BASE_NAME}.pfx
```

Copy and paste this whole script
```sh
mkdir certs 
cd certs

openssl req \
    -x509 \
    -sha256 \
    -noenc \
    -days 365 \
    -newkey rsa:2048 \
    -subj "${SUBJECT}" \
    -keyout ${KEY_FILE} \
    -out ${CA_FILE}

# Just view the CA file
# openssl x509 -text -noout -in ${CA_FILE}

openssl req \
    -out ${CSR_FILE} \
    -newkey rsa:2048  \
    -noenc  \
    -keyout ${CLIENT_KEY_FILE} \
    -subj "${CLIENT_SUBJECT}"

openssl x509 -req \
    -sha256 \
    -days 365 \
    -CA ${CA_FILE} \
    -CAkey ${KEY_FILE} \
    -set_serial 0 \
    -in ${CSR_FILE} \
    -out ${CLIENT_CRT_FILE}  

# Just view client cert
# openssl x509 -text -noout -in ${CLIENT_CRT_FILE}

# Export pkcs12 format
# openssl pkcs12 -export \
#     -in ${CLIENT_CRT_FILE} \
#     -inkey ${CLIENT_KEY_FILE} \
#     -out ${CLIENT_P12_FILE} \
#     -certfile ${CA_FILE}

# Another format
# openssl pkcs12 -export \
#     -certpbe PBE-SHA1-3DES \
#     -keypbe PBE-SHA1-3DES \
#     -nomac \
#     -inkey ${CLIENT_KEY_FILE} \
#     -in ${CLIENT_CRT_FILE} \
#     -out ${CLIENT_PFX_FILE}

ls -al
```