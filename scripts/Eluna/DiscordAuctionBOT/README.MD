# Discord Auction House Bot

This Eluna Lua script for **AzerothCore 3.3.5a** sends detailed auction listings directly to a Discord channel using a Webhook.  
It’s great for letting your community see items listed at the in-game Auction House — live and in real time!
This script uses [dkjson](http://dkolf.de/src/dkjson-lua.fsl/) to convert auction data into JSON for the Discord webhook.
Make sure to include the `dkjson.lua` file in the same folder as AuctionBOT.lua.
---

## Features

- Sends auction listing details to your Discord server
- Includes item name, level, stack size, bid and buyout cost
- Displays item thumbnail and seller's race/gender icon
- Fully customizable via config block at the top of the script

---

## Configuration

At the top of the script, you’ll find a config table:

```lua
auctionWebhookURL = "YourWebhookHERE!" -- Discord Webhook Link
itemLinkDB = "http://wow.tanados.com/database/?"
itemIconDB = "https://wow.tanados.com/database/static/images/wow/icons/large/"
botImage = "https://img.freepik.com/..."
goldEmoji = "<:gold:...>"
```