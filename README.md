# README

## In-class question (icq) app for peer instruction 

Uses Rails 5.2.3 with Devise/Google oauth2.  

Students need to be seeded as users w/correct email addresses for them to
successfully authenticate.

Admins also need to be seeded with database auth credentials.  No signups
are allowed.

---

# Implementation notes

App flow
--------

 * When a student logs in, they should be redirected to a page where questions will appear when active (show page for a given course)
   * As questions are deployed and made active, show page for course should
     refresh
   * Students who are in multiple courses should go to index page for course
     to be able to select individual show page

 * When an admin logs in, they should be redirected to course page (index)

   * Links on course index page should lead to question index for a given course
   * Links on questions should lead to poll index page for the question

 * Need to make a "magic route" for:
   1. Creation of new question, related to a given course
   2. Populating the question with any details, e.g., multiple choice options
   3. Making the question active (which should update student page)

---

# Next

 * javascript submit for student question
 * javascript data retrieval/display for responses
   * Put poll response data in easy to collect tags for plotting w/d3js
 * Admin dashboard: need to add answer and show dashboard of what's correct

---
 
 Cable

  * Need to create a channel class to subscribe to updates on polls (PollChannel)
  * after a client logs in and get redirected to /courses/:id, they should
    create a subscription to the appropriate channel
     in client in JS
     ```
     App.pollChannel = App.cable.subscriptions.create({ channel: "PollChannel",
        received: function(data) {},
     });
     ```

  * In PollChannel:
  ```
  class PollChannel < ApplicationCable::Channel
    def subscribed
      stream_from "poll_for_#{params[:course]}"
    end

    def receive(data)
      # receive data from client
    end
  end
  ```

  * broadcasting to channel:
  PollChannel.broadcast_to("poll_for_xxx", hash details for poll)

  * client send on channel
  ```
  App.pollChannel.send({ sent_by: "Paul", body: "This is a cool chat app." });
  ```
