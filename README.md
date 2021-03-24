# HomeStars Chat API

## Setup Instructions
To run this code on your local machine, follow these steps below:

1. Install Ruby
```
```

2. Install Rails & load dependencies

3.

4.

5.

## How to run code

1. cd into /homestars_chat_api/

2. enter `rails s` into your CLI

3. Either navigate to http://localhost:3000 in your browser OR install and run https://ngrok.com/ to
access API endpoints via a tool such as https://www.postman.com/.

Sample API requests with ngrok:

Create a user `POST http://910e5b29c3e6.ngrok.io/api/v1/users?username=Wizard&email=wizard@email.com&password=current_or_new_password&password_confirmation=current_or_new_password`
Create a chat room `POST http://910e5b29c3e6.ngrok.io/api/v1/chat_rooms?name=Fun%20Convo`
Send a message `POST http://910e5b29c3e6.ngrok.io/api/v1/messages?username=Wizard&chat_room_name=FunConvo&message=Hello%20everyone!`
View persistent messages in a specific chat room `GET http://910e5b29c3e6.ngrok.io/api/v1/chat_rooms/1`
Search for a user `GET http://910e5b29c3e6.ngrok.io/api/v1/users?search_username=AName`
Search for a chat room `GET http://910e5b29c3e6.ngrok.io/api/v1/chat_rooms?search_chat_room=AName`
View a specific user's stats and profile `GET http://910e5b29c3e6.ngrok.io/api/v1/users/1`
Update a user's account info `PUT http://910e5b29c3e6.ngrok.io/api/v1/users/1?username=NewUsername&email=new@email.com&password=current_or_new_password&password_confirmation=current_or_new_password`
Update a chat room's name `PUT http://910e5b29c3e6.ngrok.io/api/v1/chat_rooms/1?name=NewName`

4. To run tests, enter the following command into you CLI:
```
```

## Summary
This API includes the following features:

1. Persist chat messages within a specific channel selected by the user/consumer.

2. List all available channels.

3. Search functionality for channels and users.

4. View a channel's or user's statistics.

I also included a simple front-end interface as an example of how the API could be used for a web-app.
If I had more time to work on this project, I would have included the feature about recommending gifs.
More importantly, I would have integrated devise-jwt (JSON web tokens) with the API routes to authenticate each user's requests.
I also would have restricted who can edit a chat room's name to the user that created the chat room.

One assumption I made was that records will not be deleted, as this could skew the content of a conversation.
I also assumed that a user would want to see a sender's username, along with a message timestamp for every message in
a channel. Finally, I assumed that the API should be outputting JSON data, partly so it can be implemented with WebSockets to achieve real-time chat.

**Expand test coverage to models...
