# Dafs: Distributed Aaron File System

# Aaron Jenner - 12301154

# Install Instructions:
To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install and run postgresql - i recommend using this: https://www.bigsql.org/postgresql/installers.jsp
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Description
Dafs is my solution to the CS4032 Distributed Systems module project.

Dafs is a dropbox-esque web based file system written in Elixir with Phoenix. The distributed nature of the project is achieved by leveraging Erlang's simple method of connecting nodes together. Each node is aware of which other nodes are in existence.

# Architectural Decisions

# Directory & File Storage Service
TODO: Describe this


# Security
Secure access to user files is guarenteed by the [`Coherence`](https://github.com/smpallen99/coherence) library. Coherence acts as a token authorization system which wil restrict access to files based on a valid login. The user can only access files which were uploaded using their authorized login. The design of the system ensures that all connections are handled over https through a browser. Connections can only be formed by authorised users so ther is no need for the 3-key system which was suggested in the project brief.

# Transactions & Locking
A locking Service is implemented using [`Canary`](https://github.com/cpjk/canary). When a user goes to edit a file, canary will check whether they have the correct permissions to see and edit the file. Due to coherence, the user will only ever see files which they can edit. However, if there were multiple sessions open involving the same user, we could get issues with simultaneous file access. To work around this I use canary to temporarily halt user permissions on a file once it is being edited, and then return the permissions to user once the access is finished. This is not an ideal solution but it seems to work. Similarly in the case of multiple concurrent uploads, this will function as a first write wins system.

# Replication
TODO

