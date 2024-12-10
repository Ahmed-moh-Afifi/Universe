# Universe

**Universe** is a social media platform developed in 2024 by **Ahmed Afifi** during his freshman year at Nile University. While social media platforms are far from unique in the tech landscape, Universe reflects a personal journey of skill-building, creativity, and problem-solving.

## Table of Contents

- [About My Journey](#about-my-journey)
- [Project Features](#project-features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [References](#references)

## About My Journey

### Motivation

As a freshman computer science student, I developed Universe not just to create “another social media app,” but as an exploration of what it takes to build a scalable, user-centered platform from the ground up. I wanted to challenge myself, test my skills, and create a project that could reflect both my technical abilities and my passion for coding. More than just a tech project, Universe represents a journey of:

- **Experimentation with Real-World Technologies**: Through Universe, I explored everything from real-time data synchronization to cloud-based media storage. This helped me understand what goes on behind the scenes of large platforms.
- **Learning Through Challenges**: Along the way, I encountered complex technical challenges, like managing high volumes of media, implementing real-time features with SignalR, and building a robust API. Solving these issues taught me skills that extend beyond classroom knowledge.
- **Building with the User in Mind**: Creating a functional, enjoyable user experience became my top priority. I took every opportunity to iterate and improve the platform based on feedback from my friends and classmates, striving to make Universe feel intuitive and responsive.

### The Bigger Picture

Though Universe may not be a groundbreaking new concept, developing it has been an invaluable step toward my larger goal: to stand out as a developer, push the limits of my abilities, and contribute to the tech community. This project has also given me insights into what it takes to potentially start a company or develop impactful software. Universe serves as a stepping stone in this journey, where I learned about scalable design, user engagement, and code maintainability.

## Project Features

Universe aims to provide a streamlined social media experience with the following features:

- **User Profiles**: Users can set up a profile, upload a profile picture, and customize their space.
- **Post Sharing**: Universe supports posting images and videos, with an intuitive editor.
- **Reactions and Comments**: Real-time reaction counts enable dynamic interactions with others' posts.
- **Live Chat**: Built-in chat functionality lets users connect instantly with friends and followers, allowing private conversations alongside the social feed.
- **Live Updates with SignalR**: A core feature of Universe is its real-time update functionality, allowing users to see engagement changes instantly.
- **Efficient Media Storage**: Integrated with Cloudinary for seamless image and video storage, making the app lightweight and responsive.
- **Backend Architecture**: Modular backend design using ASP.NET Core for scalability and ease of maintenance.

## Tech Stack

### Frontend

- **Flutter**: Chosen for its ability to create beautiful, responsive interfaces across multiple platforms.
- **Dart**: The language that powers Flutter, enabling fast, efficient mobile apps.

### Backend

- **ASP.NET Core**: Used to build a secure, scalable API backend for handling requests and managing data.
- **SignalR**: Implemented for real-time updates to sync user interactions across clients.
- **Entity Framework Core**: Manages database interactions efficiently and consistently.

### Storage & Media

- **Cloudinary**: Used for storing and delivering images and videos to users without impacting app performance.

### Database

- **SQL Server**: Chosen for its reliability and strong support for relational data, which is key for social media applications. (considering to change to graph model in the future)

## Getting Started

To set up a local version of Universe, follow these steps:

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [.NET SDK](https://dotnet.microsoft.com/download/dotnet)
- SQL Server or a compatible database for development

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Ahmed-Moh-Afifi/Universe.git
   cd Universe
   ```

## References

The development of **Universe** was greatly supported by several key resources that helped me build both foundational and advanced skills in mobile and backend development. Here are some of the references that were instrumental in bringing Universe to life:

- **Flutter Complete Reference** by _Alberto Miola_  
  This comprehensive guide provided in-depth knowledge on Flutter, enabling me to create a responsive, engaging front-end experience.

- **ASP.NET Core in Action** by _Andrew Lock_  
  This book helped me understand the nuances of ASP.NET Core, from building APIs to handling data and managing security, all of which were essential for the backend of Universe.

- **Designing Data-Intensive Applications** by _Martin Kleppmann_  
  A vital resource for learning how to design and manage data effectively. This book guided me in handling complex data interactions and optimizing the backend’s performance.

- **Microsoft Documentation for SignalR and EF Core**  
  The official Microsoft documentation for SignalR and Entity Framework Core provided practical, real-world examples and guidance on implementing real-time communication and efficient data management in Universe.

These resources offered invaluable insights and techniques that shaped Universe's architecture, functionality, and user experience. If you’re interested in learning about software development, I highly recommend these resources.
