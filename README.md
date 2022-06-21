# Timely Backend Engineer Test : Google Calendar API

### 1. Problem Statement
* Timely Backend Engineer TestAs a user, I want to have my Google Calendar events for today listed on a Web interface, classified by calendar names.
* The events should import and save to db when I connect my account to Google calendar for the first time, the subsequent events which get   created/updated/deleted should be sync'd to the db automatically.

### 2. Technical requirement
* Using the latest versions of Ruby and Rails would be preferred with proper test cases and
  following Ruby coding style guides. We use RSpec for writing test cases but minitest is also
  fine.
* Using the Google Calendar APIs directly rather than using a gem would be preferred.

## System Requirements

1. Install [rvm](https://rvm.io/)

2. Install ruby 3.0.2

```
rvm install 3.0.2
```
3. Install Postgres

```
sudo apt install postgresql-12 libpq-dev
```

## Assumptions

### 1. To create Google Client_id and Client_secret
````
https://www.youtube.com/watch?v=w6rzVKBsB3A
````
### 2. For Development we are using ngrok
* In order to access google api in development enviornmant we need a secure url, for this purpose I've used Ngrok
````
https://ngrok.com/
````
* Goto config/settings/development.yml and update the host to ngrok secure url https://....
* Goto `https://console.cloud.google.com/apis/credentials` in the `OAuth 2.0 Client IDs` section.
    * update the `Authorized JavaScript origins` with he `ngrok secure url`
      ````
      Example : https://fd95-2401-4900-1c33-c-61ac-49ec.in.ngrok.io
      ````
    * Update the `Authorized redirect URIs`
      ````
      Example : https://fd95-2401-4900-1c33-c19c-84b1-77fb-6ngrok.io/auth/google_oauth2/callback
      ````
### 3. Setup ENV Database URL

create and Open .env
* Update `DATABASE_URL` in `.env` as per local `psql` creds. For example, if
  the user is `aniket` and password is `aniket`, change the variable as
  `DATABASE_URL="postgres://aniket:aniket@localhost/google_Calendar_api?encoding=utf8&pool=5&timeout=5000"

### 4. Google Client_id and client_Secret
* In rails console `EDITOR=nano rails credentials:edit` update the google client_id and client_secret

````
google_calendar:
    client_id: 
    client_secret: 
````

### 5. Add Test user
* Goto `https://console.cloud.google.com/apis/credentials/consent` in the `Test User` section.
* and `add user`
* While publishing status is set to "Testing", only test users are able to access the app.

### 6. Loom Video Link
https://www.loom.com/share/1433bafaba6c476caab20d8b6fd9bfc1
