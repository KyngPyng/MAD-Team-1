# teamSync 🚀

An intelligent, interactive project management and productivity hub built with Flutter. Designed to help teams map out milestones, coordinate active sprints, and streamline communication through a sleek, modernized interface.

---

## 👁️ Project Vision
**teamSync** serves as the central operations cockpit for tracking and managing the production workflow of the **AI for Everyday Productivity Masterclass**. In modern, fast-paced virtual project environments, information gets fractured across disjointed platforms. teamSync synthesizes these elements into a single visual ecosystem—allowing tracking of everything from daily coordination syncs to high-priority curriculum milestones.

---

## 🎯 Strategic Objectives
*   **Workflow Optimization:** Consolidate work breakdown schedules into high-impact visual tracking boards.
*   **Role-Based Access Control:** Deliver distinct dashboard frameworks curated for both Learners (who need task clarity) and Administrators (who require global metric oversight).
*   **Visual Engagement:** Provide an energetic, immersive user interface featuring custom asset integration, sleek glowing geometry, and a responsive glassmorphism aesthetic.
*   **Real-Time Progress Tracking:** Ensure time-sensitive deadlines and critical operational announcements are highlighted immediately upon authentication.

---

## 📐 Application Architecture & Features

### 🔐 Custom Authentication Interface
*   **Dynamic Visual Identity:** Features the signature **teamSync logo**—a distinctive, high-fidelity 'S' sweeping through a 'T', disintegrating into a digital pixel array from the right side.
*   **Immersive Design:** The login screen utilizes layered background geometric shapes and glowing teal and deep purple neon orbs beneath a semi-transparent frosted card container.
*   **Data Capture:** Features full input state retention utilizing `TextEditingController` to instantly capture input details alongside role selections.

### 🏡 Context-Aware Dashboard Navigation Flow
The interface features an argument passing engine via Flutter's navigation architecture. When an individual logs in, their exact credentials are sent through a map data object to populate their distinct views safely:

```text
[ Login Screen ] 
       │
       ▼ (Passes Input Name & Role Payload)
[ Home Dashboard Route ] 
       │
       ├─► Learner Workspace: Personalized Header Greeting ("Hello, [Input Name]!")
       │                      └─► Displays Urgent Deadlines & Program Track Task Navigation
       │
       └─► Admin Portal: Personalized Header Greeting ("Hello, [Input Name]!")
                              └─► Displays Global Stat Rows, Cohort Summaries, & System Status
