## Setting Up the AzerothCore SOAP Discord Bot

### Prerequisites:

Ensure you have `Python 3.7` or newer installed on your system.

You need a `Discord bot token`, which you can obtain by creating a bot on the `Discord Developer Portal`.

An AzerothCore server with `SOAP enabled` and the correct username and password for SOAP authentication.

Ensure your Discord bot has the required permissions to interact with your Discord server.


## Step 1:

Run the following commands to install the necessary dependencies:
```bash
pip install discord aiohttp
```
The Discord API library for Python.
An asynchronous HTTP client for making SOAP requests.



To avoid SSL certificate issues, you need certifi:

```bash
pip install certifi
```

## Step 2:

Go to the Discord Developer Portal.

Create a new application and add a bot to it.

Save the bot token; you will need it later.

Invite the Bot to Your Server:

On the bot page, click on the "OAuth2" tab.

Under "OAuth2 URL Generator", select bot and applications.commands.

Under "Bot Permissions", select the necessary permissions (e.g., Send Messages, Embed Links).

Copy the generated URL and open it in a browser to invite the bot to your server.

## Step 3: 
Copy the provided script into a Python file, e.g., discord_soap_bot.py.

Configure the Bot Token and SOAP URL:

Replace the placeholder in DISCORD_TOKEN with your bot token.
Replace SOAP_URL with your AzerothCore server's SOAP URL, including the SOAP username and password.
```
DISCORD_TOKEN = 'YOUR_DISCORD_BOT_TOKEN'
SOAP_URL = 'http://soapuser:password@localhost:7878/'  # Replace with your server's SOAP URL
```
Optional: 
SSL Certificates: If you encounter SSL certificate issues, you can specify the location of cacert.pem using the SSL_CERT_FILE environment variable:

```
os.environ['SSL_CERT_FILE'] = r'path\to\certifi\cacert.pem'
```

Step 4: 
Run the Python Script
```
python discord_soap_bot.py
```
Verify the Bot:

In your Discord server, verify that the bot is online.
Use the /ac and /ac-help commands to interact with the AzerothCore server.

Example commands:

```bash
/ac commands
/ac server info
/ac-help server
/ac-help account create
```

Common Issues and Troubleshooting
SSL Certificate Errors:

If you encounter SSL certificate errors, ensure you have the certifi package installed and set the SSL_CERT_FILE environment variable:
python
Copy code
os.environ['SSL_CERT_FILE'] = r'path\to\certifi\cacert.pem'
Permissions:

Ensure your bot has the necessary permissions on your Discord server to send messages and embed links.
Bot Not Responding:

Ensure the bot is online and running.
Verify that the bot token and SOAP URL are correctly configured.

