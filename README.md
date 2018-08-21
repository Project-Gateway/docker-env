# Local Docker Env

## Requirements

You'll need to have on your machine:
- Docker;
- Docker Compose;
- Include this entry on your `/etc/hosts` file: `127.0.0.1 local.pg.com`

## Bring the env up

Use the docker-compose command to control de env build/start/stop.

It's highly recommended to create a alias `dc` for docker-compose (since we'll use it all the time).
It's also recommended to create an alias for dc passing the docker-env docker-compose.yml file as parameter,
this way we can call it from any place on your machine.
Just put this lines on your profile script and restart the command line:
`alias dc=docker-compose`
`alias dco="docker-composer -f <path-to-your-docker-env-docker-compose.yml>"`

First build the containers, without initializing them (to avoid dependencies problems):
`dco build`

On the first run, you'll have to run this commands:
- `dco run login-api cp .env.example .env`
- `dco run --entrypoint="" db cp .env.example .env`
- `dco run login-api composer install`
- `dco run --entrypoint="" db composer install`
- `dco run db migrate:fresh --seed`
- `dco run web-ui npm install`
- `dco run graphql-api npm install`


To bring the env up (every time you start to work):
`dco up -d`


## Dealing with SSL certificates

If something goes wrong, use this article as reference: 
https://medium.freecodecamp.org/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec

Most of the times, the only thing that you need to do, is to tell your local system to trust on the root certificate:

On MacOS:
- Open Keychain Access on your Mac and go to the Certificates category in your System keychain. 
- Import the rootCA.pem using `File > Import Items` (file inside `services/ssl`)
- Double click the imported certificate and open the certificate info screen
- Click on `> Trust` section, and change the `When using this certificate:` option to `Always Trust`

You should be ready to go. If you need to recreate a certificate for some reason, follow the following steps.

All commands must be run inside `services/ssl` directory.

### Create the root certificate

Those steps just need to be run if, for some reason, you want to recreate the local root certificate. It's unlikely
that you'll need to do that.
This cert is used to create the domain certs.
This is the cert that you need to include on your keychain, to avoid the security errors on browser.

#### 1. Create a private key

`$ openssl genrsa -out rootCA.key 2048`
- It generates the `rootCA.key` file.

#### 2. Self-sign a certificate
`$ openssl req -x509 -new -nodes -key rootCA.key -days 3650 -out rootCA.pem`
- Fill the form:
```
Country Name (2 letter code) []:US
State or Province Name (full name) []:FLORIDA
Locality Name (eg, city) []:MIAMI
Organization Name (eg, company) []:PROJECT GATEWAY
Organizational Unit Name (eg, section) []:IT
Common Name (eg, fully qualified host name) []: pg.com
Email Address []:
```
- It will generate the `rootCA.pem` file.

### Create the domain certificate

Those steps need to be run every time you want to include a new domain.
You probably don't need to do that to make your env work.

#### 2. Create the CSR

`$ openssl req -new -key server.key -out server.csr`
- Fill the form:
```
Country Name (2 letter code) []:US
State or Province Name (full name) []:FLORIDA
Locality Name (eg, city) []:MIAMI
Organization Name (eg, company) []:PROJECT GATEWAY
Organizational Unit Name (eg, section) []:IT
Common Name (eg, fully qualified host name) []:<the domain name, e.g. local.pg.com>
Email Address []:
```
- Include the correct domain name!
- Don't include a password!
- It will generate the `server.csr` file.

#### 3. Create the signed certificate

`$ openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 3650`
- It will generate the `server.crt` file, signed with the rootCA cert.


