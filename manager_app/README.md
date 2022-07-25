# Contractor/Manager CRUD app

## Homework

Create two simple Rails applications. Use events, carried over a message broker (eg. RabbitMQ, Kafka, Amazon SQS, etc.) for inter-app communication. It's OK to use libraries, whether it's just a client (eg. bunny) or a full-on message processing system (hutch, karafka, etc). We don't want this exercise to take too much of your time, be efficient with your choices. Each application needs to have its own, separate database.

Contractor app: a simple application for payment requests where a contractor can request a payment from their manager. A payment request consists of amount, currency, and text description. The contractor should be able to see all of their payment requests, whether they're pending, accepted, or rejected.
Manager app: a simple application that displays all payment requests submitted by the contractor. The manager can only accept or reject the payment request. The acceptance/rejection of payment request should be handled by the manager app publishing an event and the contractor app processing the event to update the status for the contractor.
These are the only requirements. If you feel something is unspecified, make your own decision.

For simplicity, don't worry about any of the following:

authentication: don't implement it, and for, simplicity assume single-tenancy of each app (no user_id, no current_user)
state machines – don't worry about the elegant implementation of payment request states, just use a string/enum field)
front-end: don't worry about the styles and markup: a plain-text app with links is fine
code duplication of event handling utilities: please don't spend your time extracting the common code to a third project to make it reusable – it's fine to have it duplicated in each app
What will be evaluated in this homework:

controller code that orchestrates everything – and all classes referenced by the controller code
event handling code – and all your classes called from the event handlers

## Running the app

Set up the app databases
`docker compose run contractor rails db:setup`
`docker compose run manager rails db:setup`

Run the app
`docker compose up`

Contractor app will be available at http://localhost:3010/
Manager app will be available at http://localhost:3010/

## Approach

Two Rails app have been created and dockerised alongside their dependencies (RabbitMQ and Postgres) for the ease of managing and isolating dependencies.

For managing the event side of things, I've opted to use `hutch` gem as out of the box it gave me an easy way to interface with RabbitMQ with both publishers and consumers. I've also evaluated using Kafka with `karafka` gem. While the gem itself seemed better documented and easier to use than `hutch`, orchestrating the Kafka environment looked to take more time. Ultimately `hutch` + `RabbitMQ` combo has been chosen for the efficiency.

### Contractor app

Contractor app is a simple CRUD app where contractors will create their payment requests. Contractor can submit a request with amount, currency and description.

The creation is routed through an operation object that is responsible for creating a record in the db and calling the publisher event with the payment request params (if the paymenr request has been persisted).

Contractor app also includes a single consumer to process the decision from the manager app. This consumer receives payment request id and decision and updates the relevant record.

### Manager app

In the manager app, the pending payment requests are displayed and can be either approved or rejected.

The requests are creating through the consumer that receives a message about new payment request created. For simplicity, the records are created in Postgres DB but could as well be handled through something like Redis and removed once processed. As it stands now, once the request is processed, it gets marked as so in the db and it disappears from the list offered to the manager.

Approving or rejecting the request will trigger an operation that updates the status of the request and calls the publisher with the payment request id and decision that is ultimately picked up by the contractor app.
