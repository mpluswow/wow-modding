<img src="https://github.com/user-attachments/assets/1bd401ee-ef74-4ee9-b365-582666326e86" alt="image" width="300" height="300"/>

## Prerequisites

1. Ensure you have Python 3.7 or newer installed on your system.

2. Obtain a Discord bot token by creating a bot on the [Discord Developer Portal](https://discord.com/developers/applications).

3. Have an AzerothCore server with SOAP enabled, and the correct username and password for SOAP authentication.

4. Ensure your Discord bot has the required permissions to interact with your Discord server.

## Step 1: Install Dependencies

Run the following commands to install the necessary dependencies:

```bash
pip install discord aiohttp certifi
```

- `discord`: The Discord API library for Python.

- `aiohttp`: An asynchronous HTTP client for making SOAP requests.

- `certifi`: To avoid SSL certificate issues.

## Step 2: Set Up the Discord Bot

1. Go to the [Discord Developer Portal](https://discord.com/developers/applications).

2. Create a new application and add a bot to it.

3. Save the bot token; you will need it later.

4. Invite the Bot to Your Server:

   - On the bot page, click on the "OAuth2" tab.
   - Under "OAuth2 URL Generator," select `bot` and `applications.commands`.
   - Under "Bot Permissions," select the necessary permissions (e.g., Send Messages, Embed Links).
   - Copy the generated URL and open it in a browser to invite the bot to your server.

## Step 3: Configure and Run the Bot Script

1. Copy the provided script into a Python file, e.g., `discord_soap_bot.py`.

2. Configure the Bot Token and SOAP URL:

   - Replace the placeholder in `DISCORD_TOKEN` with your bot token.
   - Replace `SOAP_URL` with your AzerothCore server's SOAP URL, including the SOAP username and password.

   ```python
   DISCORD_TOKEN = 'YOUR_DISCORD_BOT_TOKEN'
   SOAP_URL = 'http://soapuser:password@localhost:7878/'  # Replace with your server's SOAP URL
   ```

3. **Optional: SSL Certificates**: If you encounter SSL certificate issues, specify the location of `cacert.pem` using the `SSL_CERT_FILE` environment variable:

   ```python
   os.environ['SSL_CERT_FILE'] = r'path\to\certifi\cacert.pem'
   ```

## Step 4: Run the Python Script

Run the script using Python:

```bash
python discord_soap_bot.py
```

## Step 5: Verify the Bot

1. In your Discord server, verify that the bot is online.
2. Use the `/ac` and `/ac-help` commands to interact with the AzerothCore server.

### Example Commands

- `/ac commands`
- `/ac server info`
- `/ac-help server`
- `/ac-help account create`

## Common Issues and Troubleshooting

### SSL Certificate Errors

If you encounter SSL certificate errors:

- Ensure you have the `certifi` package installed.
- Set the `SSL_CERT_FILE` environment variable:

  ```python
  os.environ['SSL_CERT_FILE'] = r'path\to\certifi\cacert.pem'
  ```

### Permissions

Ensure your bot has the necessary permissions on your Discord server to send messages and embed links.

### Bot Not Responding

- Ensure the bot is online and running.
- Verify that the bot token and SOAP URL are correctly configured.
- Ensure that the bot commands are used in the correct channel if channel restrictions are applied.
