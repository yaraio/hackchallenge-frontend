# hackchallenge-frontend
# Tracklist — Frontend

A music-themed iOS study app built in SwiftUI that gamifies task completion through a vinyl record progress ring.

## Concept

Tracklist turns your to-do list into a vinyl record. Every task you add becomes a track on the record. As you complete tasks, the ring closes. When all tasks are done, the record is full — Get into the groove.

## Features

- **Vinyl progress ring** — shows overall completion percentage, animates and spins on task completion with music note effects
- **Music player task rows** — each task expands into a full player with a scrubbable progress bar, play/pause, rewind, and fast forward
- **Real time countdown timer** — auto-starts when a task is created, counts down based on estimated time chosen by user
- **Record scratch alert** — haptic feedback pattern fires when timer runs out, sheet appears with options to mark complete, add 30 minutes, restart/continue, or edit the task
- **Task creation & editing** — shared screen handles both flows, pre-fills fields when editing, includes delete option
- **Time picker** — estimated time in 30 minute increments from 30 min to 8 hrs
- **Points system** — points awarded based on estimated time, displayed on dashboard
- **Smart sorting** — incomplete tasks float to top, completed tasks sink to bottom
- **Swipe to delete** — swipe left on any task to remove it
- **Haptic feedback** — on task completion, timer end, and play/pause

## Screens

- `ContentView` — main dashboard with vinyl ring, stats, and task list
- `TaskCreationView` — create and edit tasks
- `TaskRowView` — expandable music player embedded in each task row
- `RingProgressView` — vinyl record progress ring component

## Architecture

- **`TaskViewModel`** — `ObservableObject` managing all task state using `@Published` properties. Handles fetching, creating, completing, deleting, and locally updating tasks. Acts as the single source of truth between the UI and the network layer.
- **`NetworkManager`** — singleton class handling all HTTP requests via `URLSession`. Encodes outgoing requests as JSON and decodes responses using a generic `APIResponse<T>` wrapper. Supports GET, POST, PUT, and DELETE operations.
- **`APIResponse`** — generic decodable struct wrapping all backend responses in a consistent `{ success, data, error }` shape.

## Networking

All API calls go through `NetworkManager.shared` using `URLSession`:

GET `/api/users/<id>/tasks/` Fetch all active tasks
POST `/api/users/<id>/tasks/` Create a new task
PUT  `/api/tasks/<id>/complete/` Mark task complete, award points
DELETE | `/api/tasks/<id>/` Delete a task

Requests and responses are encoded/decoded using `JSONEncoder` and `JSONDecoder`. 


## Design

Built around a cream, gold, and dark color palette defined in a shared `Colors.swift` extension. Custom vinyl record graphic with grooves, gold label, progress arc, and record needle. Music notes animate from the center of the vinyl on task completion.

