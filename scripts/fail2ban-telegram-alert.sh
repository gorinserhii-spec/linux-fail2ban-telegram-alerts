#!/bin/bash
# fail2ban-telegram-alert.sh
# Sends daily Fail2ban ban report to Telegram

# -----------------------------------------------------------------
# ↓↓↓ PASTE YOUR CREDENTIALS HERE (from @BotFather & @userinfobot) ↓↓↓
# -----------------------------------------------------------------
BOT_TOKEN="YOUR_BOT_TOKEN_HERE"      # ← REPLACE THIS
CHAT_ID="YOUR_CHAT_ID_HERE"          # ← REPLACE THIS
# -----------------------------------------------------------------

LOG_FILE="/var/log/fail2ban.log" # Make sure Fail2ban writes its log here

# Check if the log file actually exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found at $LOG_FILE"
    exit 1
fi

DATE=$(date '+%Y-%m-%d')

# Count the total number of bans (uses 'grep -c' to count lines)
BAN_COUNT=$(grep "Ban " "$LOG_FILE" | wc -l)

# Get the last 5 unique IP addresses
# awk '{print $NF}' -> takes the last word of the line (the IP address)
# sort | uniq -> leaves only unique IPs
# tail -5 -> takes the last 5
BANNED_IPS=$(grep "Ban " "$LOG_FILE" | awk '{print $NF}' | sort | uniq | tail -5)

# Create the message
MESSAGE="🛡️ *Daily Security Report*
📅 Date: $DATE
🔒 Total bans (all time): $BAN_COUNT
🌐 Last 5 attackers (unique):
\`\`\`
$BANNED_IPS
\`\`\`"

# Send the message to Telegram using curl
# -s = "silent" mode
# -X POST = use the POST method
# -d = the data we are sending
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$MESSAGE" \
    -d parse_mode="Markdown"

echo "Telegram alert sent."