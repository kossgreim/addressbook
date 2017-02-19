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
