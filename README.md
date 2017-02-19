# AddressBook test app

## Installing

### Downloading the project

First, download the app from this repository

```
   $ git clone https://github.com/kossgreim/addressbook.git
   $ cd addressbook
   $ bundle install
```

### Database

**Postgres**

- Setup your config/database.yml file to work with your database
- Setup your database by running those commands

```
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

**Firebase**

Create file .env in the root folder *(only for development)* <br/>

```
ENV['FIREBASE_API_KEY'] = 'your firebase database secret key'
ENV['FIREBASE_DATABASE_URL'] = 'your database url'
```

For **production** don't store your variables in the .env because:

>There are typically better ways to manage configuration in production environments- such as /etc/environment managed by Puppet or Chef, heroku config, etc.

<hr>
<p>Also, add these rules in your Firebase console:</p>

```json
{
  "rules": {
    ".read": false,
    ".write": false,
      "contacts": {
        ".indexOn": ["organization_id"]
      }
  }
}
```

## Running the tests

All the test are written using Rspec, so all you need to do to is to run this command:

```
$ bundle exec rspec
```
# API Documentation

## Authorization

When you were setting up the application, I assume you run command

```bash
    $ rails db:seed
```

That command created an organization and admin account for you.
So, now you have to ne all set to start using the app and be able to sign in.

### Signing in
Send a POST request to:

__You must specify content type header:__ *Content-Type: application/vnd.api+json*

> http://<app_address>/v1/auth/sign_in

Requires email and password as params. This route will return a JSON representation of the user

Request body example:

```json
    {"email":"your@email.com", "password":"YourPasswordHere"}
```

####In case of successful sign in, you'll receive:

- Status 200 OK

- Body:
```json
    {
      "data": {
        "id": 2,
        "email": "admin@example.com",
        "provider": "email",
        "organization_id": 3,
        "first_name": "Admin",
        "last_name": "Admin",
        "uid": "admin@example.com",
        "admin": true,
        "type": "user"
      }
    }
```
- You'll get authentication headers to be able to authorize yourself as a user for each request
##### Authentication headers example:
~~~
"access-token": "wwwww",
"token-type":   "Bearer",
"client":       "xxxxx",
"expiry":       "yyyyy",
"uid":          "zzzzz"
~~~

The authentication headers consists of the following params:

| param | description |
|---|---|
| **`access-token`** | This serves as the user's password for each request. A hashed version of this value is stored in the database for later comparison. |
| **`client`** | This enables the use of multiple simultaneous sessions on different clients. (For example, a user may want to be authenticated on both their phone and their laptop at the same time.) |
| **`expiry`** | The date at which the current session will expire. This can be used by clients to invalidate expired tokens without the need for an API request. |
| **`uid`** | A unique value that is used to identify the user. This is necessary because searching the DB for users by their access token will make the API susceptible to timing attacks. |

**Info taken from [https://github.com/lynndylanhurley/devise_token_auth]*

#### When sign in wasn't successful

In response you'll get:

- Status 401
- Body

```json
    {
      "errors": [
        "Invalid login credentials. Please try again."
      ]
    }
```

## Registration

Send POST request to:
__You must specify content type header:__ *Content-Type: application/vnd.api+json*
>http://<app-ddress>/v1/auth

with body:

```json
{
	"first_name": "Name",
	"last_name": "LastName",
	"email": "youremail@example.com", 
	"password": "yourStrongPassword",
	"organization_id": 1
}
```
*How to get attribute **organization_id** you can find at **[Organizations](#organizations)**

### When registration was successful

You'll receive:
- Status 200 OK
- Authorization data, see "Authentication headers example" at [Authorization](#authorization)
- User's JSON representation in the response's body

```json
    {
      "status": "success",
      "data": {
        "id": 3,
        "email": "youremail@example.com",
        "provider": "email",
        "organization_id": 1,
        "first_name": "Name",
        "last_name": "LastName",
        "uid": "youremail@example.com",
        "created_at": "2017-02-19T14:07:58.006Z",
        "updated_at": "2017-02-19T14:07:58.084Z",
        "admin": false,
        "type": "user"
      }
    }
```

## Organizations