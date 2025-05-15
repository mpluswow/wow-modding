# 🪙 Treasure Goblin Integration for AzerothCore

This project adds a **Treasure Goblin** encounter to your AzerothCore server. Please follow the instructions below to install it correctly.

---

## 📁 Server-Side Installation

1. Copy the entire `Treasure Goblin` folder into your server's `lua_scripts` directory:

```
yourserver/src/server/scripts/lua\_scripts/

```

2. Copy the provided **DBC files** into your AzerothCore Game Data DBC folder:
```

$USER/server/azerothcore/env/dist//bin/data/DBC/

```

---

## 💻 Client-Side Setup

1. Copy the `patch-Z.MPQ` file into your client’s `Data` folder:
```

World of Warcraft/Data/

```

---

## 🛠 SQL Configuration

> **Note:** These SQL files are specifically tailored for **AzerothCore**.

- If you're using **AzerothCore**, simply execute the provided SQL files on your acore_world database.


---

## ⚠️ Compatibility

This script is designed and tested for:
- AzerothCore 3.3.5a (Wrath of the Lich King)
- Eluna Lua Engine

For other cores or engines, manual adjustments may be required.

---

