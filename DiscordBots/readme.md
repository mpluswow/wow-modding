## Installation Commands
```bash
pip install discord.py
pip install aiohttp
```
## Prerequisites
Python 3.7 or higher is required to run this bot.
Ensure you have pip (Python package installer) installed.
Installing Required Packages

discord.py - This package provides a Python API wrapper for the Discord API.

aiohttp - This package is used for asynchronous HTTP requests, allowing the bot to send SOAP commands to the AzerothCore server.

SSL Certificate (Windows Only): If you are on Windows, you may need to set the SSL_CERT_FILE environment variable to point to the cacert.pem file.

Locate the cacert.pem file in your Python installation directory. If you're using the certifi package, it might be located at:

```
C:\Users\<YourUsername>\AppData\Local\Programs\Python\Python<version>\Lib\site-packages\certifi\cacert.pem
```
Set the `SSL_CERT_FILE` environment variable in your script:

```
os.environ['SSL_CERT_FILE'] = r'C:\Path\To\cacert.pem'
```

## Running the Bot
After installing the required packages, you can run the bot with the following command:

```bash
python app.py
```
