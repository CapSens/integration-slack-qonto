# CapsensQonto

This is the source code of the live website [**https://qonto-slack.capsens.eu/**](https://qonto-slack.capsens.eu/)

It is a site that allows any user to authenticate with their Slack and Qonto account and get notified about new incoming or
outcoming transactions.

## Install and setup

### 1. Install Elixir's dependencies

`mix.deps.get`

### 2. Setup the development environment

fill in necessary variables (eg.: `DATABASE_USERNAME`) in **config/dev.exs** :

  - either in your environment (bash, zsh, ...)
  - eithir directly in this file (be careful not to commit your variables, this file is versioned)
  
### 3. Create and setup the database

`mix ecto.setup`
  
### 4. Install JavaScript's dependencies

`cd assets; yarn` 

OR

`cd assets; npm install`

### 5. Launch server

`mix phx.server`
  
You can now reach the server at [**http://localhost:4000**](http://localhost:4000)

## `Integration`

An `Integration` is a database object representing a Slack/Qonto account couple. Any user can create and edit multiple integrations.
A periodic report will be sent to the integration's specified Slack channel.

## Setup the scheduler

Un scheduler est paramétré par défaut pour envoyer un rapport par intégration toutes les 5 minutes. Cela peut-être changé dans
**config/config.exs**
A scheduler is set up by default to send a report for each integration every 5 minutes. You change this in **config/config.exs**

