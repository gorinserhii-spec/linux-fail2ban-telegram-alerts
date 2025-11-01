#!/bin/bash
# update_webpage.sh
# Updates the Fail2ban status webpage

LOG_FILE="/var/log/fail2ban.log"
HTML_FILE="/var/www/html/status.html" # Specify your path to index.html

# Count the total number of bans
BAN_COUNT=$(grep -c "Ban " "$LOG_FILE")

# Get the last 5 unique IPs
LAST_BANS=$(grep "Ban " "$LOG_FILE" | tail -10 | awk '{print $NF}' | sort | uniq | tail -5)

# --- Generate HTML ---
echo "<html>" > "$HTML_FILE"
echo "<head><title>Fail2ban Status</title><meta http-equiv='refresh' content='60'></head>" >> "$HTML_FILE"
echo "<body style='font-family: Arial, sans-serif; padding: 20px;'>" >> "$HTML_FILE"
echo "<h1>🛡️ Live Security Status</h1>" >> "$HTML_FILE"
echo "<p>Last Update: $(date)</p>" >> "$HTML_FILE"
echo "<h2>Total IPs Banned (All Time): $BAN_COUNT</h2>" >> "$HTML_FILE"
echo "<h3>Recent Attackers (Last 5):</h3>" >> "$HTML_FILE"
# <pre> is needed to preserve line breaks
echo "<pre style='background-color: #f4f4f4; padding: 10px; border-radius: 5px;'>" >> "$HTML_FILE"
echo "$LAST_BANS" >> "$HTML_FILE"
echo "</pre>" >> "$HTML_FILE"
echo "</body></html>" >> "$HTML_FILE"