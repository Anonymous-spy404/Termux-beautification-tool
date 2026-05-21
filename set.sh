#!/data/data/com.termux/files/usr/bin/env bash

# Paths
MOTD_FILE="$PREFIX/etc/motd"
BASHRC_FILE="$HOME/.bashrc"

# Remove MOTD file (prevents duplicate banner on login)
if [[ -f "$MOTD_FILE" ]]; then
    rm -f "$MOTD_FILE"
    echo "✅ Removed $MOTD_FILE (MOTD will no longer show)"
else
    echo "ℹ️  MOTD file not found, nothing to remove."
fi

# Function to generate full bashrc content with custom name
generate_bashrc() {
    local name="$1"
    local escaped_ps1_name=$(printf '%s\n' "$name" | sed 's/[\\&]/\\&/g')
    local escaped_banner_name=$(printf '%s\n' "$name" | sed 's/[\/&]/\\&/g')

    cat <<EOF
# ==========================================
# Custom banner (ASCII logo)
# ==========================================
c1="\\e[1;34m"
c2="\\e[39m"
STOP="\\e[0m"

LOGO="⠀⠀⠀⠀⠀⠠⠤⣀⠀⢀⣀⠀⠀⠓⢄⠈⢚⠵⢤⡀⢀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡕⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⠔⠀⡠⠄⠀⠀⠈⢀⠖⠀⠐⠣⠆⡤⡀⠉⡮⠤⡰⠀⠃⠀⠀⠀⠀⠀⠀⢆⠀⠀⠀⠀⠀⠀⡁⡀⠘⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣀⢴⠅⡴⠮⠀⡀⢀⠔⠂⡏⠀⢠⠠⠀⠀⠈⠚⠦⠈⣉⠝⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢁⠀⠑⢡⠀⠀⠀⠀⠀⠀⠀
⠀⣀⡲⣖⡩⠤⠀⠸⣝⠁⠀⢸⠀⢀⠀⡄⡄⠠⠔⢢⠁⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⢄⣀⠀⠀⠀⢠⠀⡌⡎⢆⠃⠈⡆⠀⠀⠀⠀⠀⠀
⠃⣠⠞⠁⠀⠀⠀⢀⠅⠙⠁⠂⠀⠈⠀⠀⠖⠝⠀⠀⠀⢀⣀⠠⠤⠒⠒⠈⠉⠉⠉⠁⠀⠀⠀⠉⣍⣁⡚⠊⠬⢀⡆⡇⠀⠀⡀⠀⠀⠀
⠀⣇⠀⠀⠀⠀⢀⣜⡀⢀⣀⡆⢰⠀⠎⠜⠀⣄⠦⠚⠊⣁⡤⠀⠀⠀⠀⠀⠀⠀⠐⠒⢀⣀⣀⣀⠭⠴⠆⠛⠓⠒⠨⡍⠩⢤⡤⠄⠀⢀
⠀⠈⠉⠐⠒⠊⠉⠀⠀⠀⠀⡗⢡⣦⣧⣶⣿⣶⣶⠒⠋⠁⢀⣀⡠⠤⠤⠒⠒⠊⣉⠩⢛⠦⢄⡀⠀⠀⡀⠤⠀⠀⠈⠀⠀⠀⣀⣴⣪⣷
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⢿⣿⣿⡿⠿⠟⠓⠚⠋⣭⠀⠀⠀⠀⢀⣀⠀⢐⣒⡀⠈⢭⣐⡲⠀⠀⠒⠚⣡⣴⣶⣶⣶⣿⣿⣿⣿⣿
⠀⠀⣀⣀⡠⠤⠤⠄⠲⡶⢝⣫⠭⠏⣡⣤⠌⠉⠁⠀⠈⠀⠀⠀⠀⠀⠈⠉⠀⠠⠬⠉⠠⠤⠤⣍⣁⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠥
⠁⠀⠀⠀⠀⠀⣔⡪⢤⣤⣤⣤⣄⣒⣣⣀⣀⣤⣤⣾⣧⣀⣀⣤⣤⣴⣶⣢⣼⣤⣤⣆⣲⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀
⣧⣶⣷⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⣟⠉⣯⠉⠉⠀⠀⠐⠊⢹⠙⢿⡞⢹⣿⣿⢋⡴⣞⣿⣿⣿⡝⠋⠃
⠀⠉⠉⠉⠛⠛⠛⠛⠛⠛⣻⣿⢿⣿⢱⢬⡙⡿⣿⡿⠿⠛⠁⠀⠀⡟⠰⣿⡇⣀⠀⠀⠀⠀⠀⠀⠀⢗⣲⣾⣿⣾⣿⡿⣿⣏⠙⢿⠀⠀
⠀⠀⠀⠀⠀⢀⣔⣭⣭⣒⢭⡀⢸⡿⣼⡶⣷⣧⠈⠃⠀⠀⠀⠀⠀⠙⠺⠿⠃⠁⠀⠀⠀⠀⠀⠀⠀⣁⣾⣽⣟⣏⡿⡹⠉⠻⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡞⣾⣿⣿⣿⣿⣮⣮⣄⠱⡷⣏⣿⡆⠀⠀⠀⠀⠀⠀⠀⢀⣀⠤⠤⠤⠤⠤⠤⢀⡀⠐⣯⣳⣿⠟⢋⡔⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡇⣿⣿⣿⣿⣿⣿⣿⣿⣷⣬⡪⡉⠻⡄⠀⣠⡀⠀⡴⠚⠁⢀⣠⣤⣤⣤⠀⠀⠀⣆⣢⣬⣿⣿⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣦⡋⢢⠀⠀⠀⠀⠉⠉⠁⠉⠀⠀⠀⠀⣥⣿⣿⣿⣿⣧⣀⣀⣀⡀⢠⣤⣔⣒⣤
⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⢿⣿⣿⣷⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⢀⣤⣤⣶⣶⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠈⠲⢿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠉⠻⢿⡿⠿⠟⠃⣀⠥⠚⡵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣦⡀⠀⠈⠉⠉⠉⠀⠀⢸⡗⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠉⢷⠀⠀⠀⠀⠀⠀⠀⢰⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⡇⠀⠀⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⡾⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⠀⠀⠀⠀⠀⠀⣷⠀⠀⠀⠀⠀⢠⡇⠀⡄⡀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣷⠢⢤⣀⠀⠀⢽⣧⠀⠀⠀⠀⢸⡇⠸⡹⢟⣦⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
  \033[1;92m$escaped_banner_name"

printf "%b" "\${c1}\${LOGO}\${STOP}\n"

# ==========================================
# Custom prompt
# ==========================================
PS1='\[\033[0;94m\]┌────T─I─M─E────┐┌─────D─A─T─E────>
\[\033[0;94m\]|─[ \[\033[0;93m\]\@ \[\033[0;94m\]]──────[ \[\033[0;93m\]\D{%a-%b-%d} \[\033[0;94m\]]
\[\033[0;94m\]|─[\[\033[0;96m\]\w\[\033[0;94m\]]
\[\033[0;94m\]└─>\[\033[0;91m\]$escaped_ps1_name\[\033[0;94m\][~]:#\[\033[1;92m\] '

EOF
}

# Main
main() {
    echo "=========================================="
    echo "  Termux .bashrc Customizer"
    echo "=========================================="
    read -p "Enter your name (replaces 'Victor😈'): " user_name

    if [[ -z "$user_name" ]]; then
        echo "Error: Name cannot be empty. Exiting."
        exit 1
    fi

    echo "Generating new .bashrc with name: $user_name"

    # Backup existing .bashrc
    if [[ -f "$BASHRC_FILE" ]]; then
        backup="${BASHRC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$BASHRC_FILE" "$backup"
        echo "✅ Backup created at $backup"
    fi

    # Write new .bashrc
    generate_bashrc "$user_name" > "$BASHRC_FILE"
    echo "✅ .bashrc written"

    # Apply immediately
    source "$BASHRC_FILE"
    echo "✅ .bashrc sourced – banner and prompt active now!"

    echo ""
    echo "🎉 Done! MOTD removed, all customisation now in ~/.bashrc"
}

main
