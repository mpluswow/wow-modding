import os
import discord
from discord.ext import commands
import aiohttp
import xml.etree.ElementTree as ET

# Set the SSL_CERT_FILE environment variable
os.environ['SSL_CERT_FILE'] = r'C:\Users\Administrator\AppData\Local\Programs\Python\Python312\Lib\site-packages\certifi\cacert.pem'

# Replace with your actual bot token
DISCORD_TOKEN = '...'

# AzerothCore SOAP connection settings
SOAP_URL = 'http://soapuser:password123@localhost:7878/'  # Replace with your server's SOAP URL

# Define bot with application commands (slash commands)
intents = discord.Intents.default()
client = discord.Client(intents=intents)
tree = discord.app_commands.CommandTree(client)

# Dictionary to store help information for AzerothCore SOAP commands
SOAP_HELP = {
    "server": "Provides information about the server. Available subcommands:\n"
              "- `server info`: Displays server information.\n"
              "- `server status`: Shows the current status of the server.\n"
              "- `server shutdown`: Initiates a server shutdown with optional delay.",
    "server info": "Displays detailed information about the server's status, including uptime, connected players, etc.",
    "server status": "Shows the current status of the server, such as the number of players online and server uptime.",
    "server shutdown": "Shuts down the server. Usage:\n`server shutdown [delay in seconds]`."
}

async def send_soap_command(command):
    """
    Send a SOAP command to the AzerothCore server asynchronously and return the parsed result.
    """
    soap_envelope = f"""
    <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" 
        xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" 
        xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" 
        xmlns:xsd="http://www.w3.org/1999/XMLSchema" 
        xmlns:ns1="urn:AC">
        <SOAP-ENV:Body>
            <ns1:executeCommand>
                <command>{command}</command>
            </ns1:executeCommand>
        </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>
    """

    try:
        async with aiohttp.ClientSession() as session:
            async with session.post(SOAP_URL, data=soap_envelope) as response:
                if response.status == 200:
                    response_text = await response.text()

                    # Parse the response to extract the <result> content
                    try:
                        root = ET.fromstring(response_text)
                        result_element = root.find('.//result')
                        if result_element is not None:
                            return result_element.text.strip()
                        else:
                            return "Error: Could not find <result> in SOAP response."
                    except ET.ParseError:
                        return "Error: Unable to parse SOAP response."
                else:
                    return f"SOAP Error: {response.status} - {response.reason}"
    except Exception as e:
        return f"SOAP Exception: {str(e)}"

@client.event
async def on_ready():
    print(f'Bot is ready and logged in as {client.user}')
    await tree.sync()
    print("Slash commands synced successfully.")

@tree.command(name="ac", description="Execute a SOAP command on AzerothCore")
async def execute(interaction: discord.Interaction, command: str):
    # Restrict access to users with a specific role
    allowed_role_name = "Remote"  # Replace with the role name that has access
    if not any(role.name == allowed_role_name for role in interaction.user.roles):
        await interaction.response.send_message("You do not have permission to use this command.", ephemeral=True)
        return

    await interaction.response.send_message("Processing command, please wait...", ephemeral=True)

    async def process_soap_command():
        try:
            response = await send_soap_command(command)
            if len(response) > 2000:
                chunks = [response[i:i + 2000] for i in range(0, len(response), 2000)]
                for chunk in chunks:
                    await interaction.followup.send(chunk)
            else:
                embed = discord.Embed(title="Server Remote", description=response, color=discord.Color.blue())
                await interaction.followup.send(embed=embed)

        except Exception as e:
            await interaction.followup.send(f"An error occurred: {str(e)}")

    client.loop.create_task(process_soap_command())

@tree.command(name="ac-help", description="Get help for AzerothCore SOAP commands")
async def soaphelp(interaction: discord.Interaction, command: str):
    help_text = SOAP_HELP.get(command.lower(), f"No help information available for '{command}'.")
    embed = discord.Embed(title=f"Help: {command}", description=help_text, color=discord.Color.green())
    await interaction.response.send_message(embed=embed, ephemeral=True)  # Keep help responses ephemeral

client.run(DISCORD_TOKEN)
