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
So, now you're all set to start using the app and be able to sign in.

### Signing in
Send a POST request to:

> http://app_address/v1/auth/sign_in

**You must specify content type header:** *Content-Type: application/vnd.api+json*

Requires email and password as params. This route will return a JSON representation of the user

Request body example:

```json
    {"email":"your@email.com", "password":"YourPasswordHere"}
```

#### In case of successful sign in, you'll receive:

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

*Info taken from **[devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth)**

#### When sign in wasn't successful:

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

**You must specify content type header:** *Content-Type: application/vnd.api+json*

>http://app_address/v1/auth

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
How to get attribute **organization_id** you can find at **[Organizations](#organizations)**

#### When registration was successful:

You'll receive:
- Status 200 OK
- Authorization data, see "Authentication headers example" at [Authorization](#authorization) for more details
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

### Getting list of organizations
List of organizations is public an available, so clients can provide for its users 
the ability to choose an organization for registration.

To get the list, you need to send GET request to:

>http://app_address/v1/organizations

In response you'll get:

- Status 200 OK
- List of organizations

example:

```json
    {
      "data": [
        {
          "id": "1",
          "type": "organizations",
          "attributes": {
            "name": "test"
          }
        },
        {
          "id": "2",
          "type": "organizations",
          "attributes": {
            "name": "First Organization"
          }
        },
        {
          "id": "3",
          "type": "organizations",
          "attributes": {
            "name": "First Organization Test"
          }
        }
      ],
      "links": {}
    }
```

*You can use this list for registration, for more info look at: **[Registration](#registration)***

### Create a new organization
**Admins only can perform this action**

To create a new organization, you'll have to send POST request to:

>http://app_address/v1/organizations

**You must specify content type header:** *Content-Type: application/vnd.api+json*

With body:

```json
    {
      "data":{
        "type": "organizations",
        "attributes": {
          "name": "Your organization name"
        }
      }
    }
```

#### When request was successful

You'll get:

- Status 201 Created
- Organization's JSON representation

```json
{
  "data": {
    "id": "4",
    "type": "organizations",
    "attributes": {
      "name": "Your organization name"
    }
  }
}
```

#### When request wasn't successful

You'll get:

- Status 422 Unprocessable Entity
- Errors explanation

```json
    {
      "errors": [
        {
          "source": {
            "pointer": "/data/attributes/name"
          },
          "detail": "is too short (minimum is 2 characters)"
        }
      ]
    }
```

### Updating organizations
**Admins only**

To update organization, you'll have to send PATCH request to:

>http://app_address/v1/organizations/:id

**You must specify content type header:** *Content-Type: application/vnd.api+json*

With body:

```json
    {
      "data":{
        "type": "organizations",
        "attributes": {
          "name": "Your organization NEW name"
        }
      }
    }
```

#### When request was successful

You'll get:

- Status 200 Ok
- Updated organization's JSON representation

```json
{
  "data": {
    "id": "4",
    "type": "organizations",
    "attributes": {
      "name": "Your organization NEW name"
    }
  }
}
```

#### When request wasn't successful

You'll get:

- Status 422 Unprocessable Entity
- Errors explanation (example)

```json
    {
      "errors": [
        {
          "source": {
            "pointer": "/data/attributes/name"
          },
          "detail": "is too short (minimum is 2 characters)"
        }
      ]
    }
```

### Deleting organizations
**Admins only**

To delete an organization, you'll have to send DELETE request to:

>http://app_address/v1/organizations/:id

#### After successful deleting

You'll get:

- Status 204 No Content

## Contacts

### Get contacts list for an Organization

To get the list, you need to send GET request to:

>http://app_address/v1/organizations/:organization_id/contacts

In response you'll get:

- Status 200 OK
- List of contacts for the organization

example:

```json
    {
      "data": [
        {
          "id": "-KdHomP_NKE5GyjiUP_B",
          "type": "contacts",
          "attributes": {
            "first_name": "John",
            "last_name": "Smith",
            "email": "john@smith123.corp"
          }
        },
        {
          "id": "-KdHpGumWBogbu_EtCLs",
          "type": "contacts",
          "attributes": {
            "first_name": "Mike",
            "last_name": "Ross",
            "email": "mike@ross.com"
          }
        }
      ]
    }
```

### Create a new contact

To create a new contact, you'll have to send POST request to:

>http://app_address/v1/organizations/:organization_id/contacts

**You must specify content type header:** *Content-Type: application/vnd.api+json*

With body:

```json
    {
      "data": 
        {
          "type": "contacts",
          "attributes": {
            "first_name": "Sheldon",
            "last_name": "Cooper",
            "email": "drsheldoncooper@yahoo.com"
          }
        }
    }
```

#### When request was successful

You'll get:

- Status 201 Created
- Contact's JSON representation

```json
{
  "data": {
    "id": "-KdMYVq_WXNmIwF8OZmx",
    "type": "contacts",
    "attributes": {
      "first_name": "Sheldon",
      "last_name": "Cooper",
      "email": "drsheldoncooper@yahoo.com"
    }
  }
}
```

#### When request wasn't successful

You'll get:

- Status 422 Unprocessable Entity
- Errors explanation (example)

```json
    {
      "errors": [
        {
          "source": {
            "pointer": "/data/attributes/last_name"
          },
          "detail": "is too short (minimum is 2 characters)"
        }
      ]
    }
```

### Updating contact

To update organization, you'll have to send PATCH request to:

>http://app_address/v1/organizations/:organization_id/contacts/:id

**You must specify content type header:** *Content-Type: application/vnd.api+json*

With body:

```json
    {
      "data": 
        {
          "type": "contacts",
          "attributes": {
            "first_name": "Sheldon",
            "last_name": "Shamy",
            "email": "drsheldoncooper@yahoo.com"
          }
        }
    }
```

#### When request was successful

You'll get:

- Status 200 Ok
- Updated contact's JSON representation

```json
    {
      "data": {
        "id": "-KdMYVq_WXNmIwF8OZmx",
        "type": "contacts",
        "attributes": {
          "first_name": "Sheldon",
          "last_name": "Shamy",
          "email": "drsheldoncooper@yahoo.com"
        }
      }
    }
```

### Deleting organizations

To delete a contact, you'll have to send DELETE request to:

>http://app_address/v1/organizations/:organization_id/contacts/:id

#### After successful deleting

You'll get:

- Status 204 No Content



# Built With

* [Rails 5.0.1](http://rubyonrails.org/) - Framework used
* [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth) - Token based authentication for Rails JSON APIs

# Author

- **Ivan Lukasevych**