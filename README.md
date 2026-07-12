# teamSync

A dedicated mobile project tracking application designed to streamline workspace management and deliverable tracking for virtual interns.

## Purpose & Objective
The primary objective of **teamSync** is to bridge the gap between complex web-based project dashboards and mobile productivity. By transforming dense group tracks and milestone timelines into an intuitive, mobile-first interface, teamSync allows users to view synchronized team progress, track strict sprint deadlines, and coordinate project management tasks seamlessly on the go.

## Target User Roles
*   **Learners / Interns:** Access localized group workspaces, monitor completion percentages, and review exact criteria for required milestone submissions.
*   **Admins / Managers:** Track team-wide sprint completion, oversee project timelines, and manage multi-tier track deliverables.

## Core Features
*   **Authentication & Auto-Sync:** Recognizes user identity at login to automatically pull and synchronize the specific team track workspace tied to that user's profile email.
*   **Phase-Driven Milestone Tracking:** Groups project progress into clean, interactive weekly timelines that focus heavily on actionable deliverables over static documentation.
*   **Sprint Breakdown Checklists:** Offers a granular look into specific task requirements, sub-tasks, and individual milestone completion statuses.
*   **Adaptive View Filters:** Allows users to parse tasks instantly by completion state (All, In Progress, Completed, Planning) to maximize focus.

## Application Architecture & User Flow

The navigation pipeline utilizes role-based routing payloads to serve specific dashboard layouts depending on the user type:

```text
[ Login Screen ]
    |
    ▼ (Passes Input Name & Role Payload)
[ Home Dashboard Route ]
    |
    ├─► Learner Workspace: Personalized Header Greeting ("Hello, [Input Name]!")
    |   └─► Displays Urgent Deadlines & Program Track Task Navigation
    |
    └─► Admin Portal: Personalized Header Greeting ("Hello, [Input Name]!")
        └─► Displays Global Stat Rows, Cohort Summaries, & System Status
