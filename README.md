## vapir

Visualized API Requests

## Synopsis

Vapir, short for "Visualized API Requests", is a utility for documenting API's with interactive testing capabilities.
	
## Goals

Full application to be written with Pheonix, an Elixir based web framework

## Getting Started

Run the following commands in cloned respository
```
vagrant up
```

Run the following commands in the vagrant VM
```
cd /vagrant/vapir/
mix deps.get
mix phoenix.server
```

## How To Use

URL Syntax:
```
http://127.0.0.1:4000/api/?url=https://api.exampleurl.com/api/v1/&username=apiuser&password=apipassword
```
