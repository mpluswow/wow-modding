## What is Eluna?

**Eluna** is a **Lua scripting engine** that extends the functionality of the World of Warcraft server emulator **AzerothCore**.

It provides an easy-to-use, dynamic way to customize the game environment without needing to modify or recompile the server’s C++ core. 

With Eluna, you can write scripts in Lua—a lightweight, fast, and embeddable scripting language used extensively in the gaming industry—to create custom game logic, 
automate processes, and build new systems in the game world.

### Key Features of Eluna:

- **Lightweight Scripting**: Eluna uses Lua, which is designed to be simple, fast, and efficient. Lua's syntax is easy to learn, especially for beginners, making it accessible for developers with various levels of experience.

- **Dynamic Changes**: Scripts written in Lua using Eluna can be applied immediately without requiring you to recompile the server or restart it. This feature enables faster iteration and testing.

- **Wide Range of Capabilities**: 

Through Eluna’s API, you can interact with game objects, players, creatures, and other aspects of the game world to:
  - Spawn and manage NPCs and objects
  - Track player statistics and create custom achievements
  - Create and manage events triggered by actions in the game world
  - Handle complex in-game systems, such as custom quests, spells, and instances

### How Eluna Works with AzerothCore

**AzerothCore** is a **C++-based** World of Warcraft server emulator for the Wrath of the Lich King expansion (version 3.3.5a). 

While AzerothCore’s C++ core is efficient, making changes directly to the core code requires a deep understanding of C++ and may involve recompiling the server, which is time-consuming.

Eluna simplifies this process by allowing you to write scripts in **Lua**, a much easier and faster language to work with, especially for smaller tweaks and customizations. These scripts communicate with AzerothCore through Eluna’s **API**, which offers functions to interact with the game world, players, NPCs, and more.

### Why Use Eluna?

1. **No Recompiling Required**: 

With Eluna, you can make changes without recompiling the server. This means you can iterate quickly—test new scripts, add custom features, and fix bugs without interrupting your server’s uptime.

2. **Easy to Learn**: 

Lua is a beginner-friendly language with a simple syntax. Even if you’re new to programming, Lua's learning curve is gentle, allowing you to start developing right away.

3. **Highly Customizable**: 

Eluna provides access to a wide range of game elements. Whether you want to create custom NPCs, modify player abilities, implement custom events, or even create entirely new gameplay mechanics, Eluna gives you the flexibility to do so.

4. **Robust API**: 

Eluna’s API includes hundreds of functions for manipulating the game world, player interactions, NPCs, spells, events, and more. This extensive API allows you to build complex systems, manage gameplay events, and extend the game in any way you want.

5. **Modular Development**: 

Lua scripts can be added or removed as needed without affecting the rest of the server. This modularity helps keep your codebase clean and organized, making it easier to maintain in the long run.

