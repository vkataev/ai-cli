#!/bin/sh
set -eu

bindir="${XDG_BIN_HOME:-$HOME/.local/bin}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"
mandir="$datadir/man/man1"

mkdir -p "$bindir"
mkdir -p "$mandir"

install_file() {
    src="$1"
    dst="$2"

    cp "$src" "$dst"
    chmod 755 "$dst"
}

install_man() {
    src="$1"
    dst="$2"

    cp "$src" "$dst"
    chmod 644 "$dst"
}

CLI=ai

case "$(uname -s)" in
    MINGW64*)CLI=ai.exe ;;
esac

install_file $CLI "$bindir/ai"
install_man ai.1 "$mandir/ai.1"

echo
echo "Installed:"
echo "  executable: $bindir/ai"
echo "  man page:   $mandir/ai.1"
echo

#
# PATH
#
case ":$PATH:" in
    *":$bindir:"*)
        ;;
    *)
        echo "Add this to your shell startup file:"
        echo "    export PATH=\"$bindir:\$PATH\""
        echo
        ;;
esac

#
# MANPATH
#
# Most systems automatically search ~/.local/share/man.
# If not, suggest adding MANPATH.
#
if man -w ai >/dev/null 2>&1; then
    echo "man page available immediately."
else
    echo "If 'man ai' does not work, add:"
    echo "    export MANPATH=\"$datadir/man:\${MANPATH:-}\""
    echo
fi
