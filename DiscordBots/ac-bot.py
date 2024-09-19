import os
import discord
from discord.ext import commands
import aiohttp  # Import aiohttp for asynchronous HTTP requests
import xml.etree.ElementTree as ET  # For parsing the SOAP response XML

# Set the SSL_CERT_FILE environment variable
os.environ['SSL_CERT_FILE'] = r'C:\Users\Administrator\AppData\Local\Programs\Python\Python312\Lib\site-packages\certifi\cacert.pem'

# Replace with your actual bot token
DISCORD_TOKEN = 'YOUR_DISCORD_BOT_TOKEN'

# AzerothCore SOAP connection settings
# Create separate game account for SOAP, acc create soap password -1, enable soap in worldserver.conf !
SOAP_URL = 'http://soapuser:password@localhost:7878/'  # Replace with your server's SOAP URL

# Define bot with application commands (slash commands)
intents = discord.Intents.default()  # Default intents are usually sufficient
client = discord.Client(intents=intents)
tree = discord.app_commands.CommandTree(client)

async def send_soap_command(command):
    """
    Send a SOAP command to the AzerothCore server asynchronously and return the parsed result.
    """
    # Create the SOAP XML envelope
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
        # Send the SOAP request asynchronously
        async with aiohttp.ClientSession() as session:
            async with session.post(SOAP_URL, data=soap_envelope) as response:
                # Check if the response is OK
                if response.status == 200:
                    # Read the response text asynchronously
                    response_text = await response.text()

                    # Parse the response to extract the <result> content
                    try:
                        # Parse the XML response
                        root = ET.fromstring(response_text)
                        
                        # Find the <result> element
                        result_element = root.find('.//result')
                        
                        # Extract the text from the <result> element and strip any leading/trailing whitespace
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
    # Sync the slash commands
    await tree.sync()
    print("Slash commands synced successfully.")

@tree.command(name="ac", description="Execute a SOAP command on AzerothCore")
async def execute(interaction: discord.Interaction, command: str):
    """
    Slash command to execute a SOAP command on AzerothCore asynchronously.
    Usage: /ac <command>
    """
    # Send an initial message to let the user know the command is being processed
    await interaction.response.send_message("Processing command, please wait...", ephemeral=True)
    
    # Perform the SOAP command processing in a separate task
    async def process_soap_command():
        try:
            response = await send_soap_command(command)  # Await the async function

            # Handle cases where the response may be too long for a single message
            if len(response) > 2000:
                # Split the response if it's longer than Discord's message limit
                chunks = [response[i:i + 2000] for i in range(0, len(response), 2000)]
                for chunk in chunks:
                    await interaction.followup.send(chunk)
            else:
                # Create an embed with a light blue color and the title 'Server Remote'
                embed = discord.Embed(title="AzerothCore Remote", description=response, color=discord.Color.blue())
                
                # Update the message with the result using followup
                await interaction.followup.send(embed=embed)

        except Exception as e:
            # Handle any unexpected errors gracefully
            await interaction.followup.send(f"An error occurred: {str(e)}")

    # Run the processing in the background
    client.loop.create_task(process_soap_command())

@tree.command(name="ac-help", description="Get help for AzerothCore SOAP commands")
async def soaphelp(interaction: discord.Interaction, command: str):
    """
    Slash command to get help for AzerothCore SOAP commands.
    Usage: /ac-help <command>
    """
    help_text = SOAP_HELP.get(command.lower(), f"No help information available for '{command}'.")
    
    # Create an embed for the help information
    embed = discord.Embed(title=f"AC-Help: {command}", description=help_text, color=discord.Color.green())
    
    # Send the help embed
    await interaction.response.send_message(embed=embed)

# Run the bot with the specified token
client.run(DISCORD_TOKEN)
