#!/bin/bash

# fail if any statement fails
set -e
# download the latest version of bat-wrapper
echo "
==============================
=      =======  =====        =
=  ===  =====    =======  ====
=  ====  ===  ==  ======  ====
=  ===  ===  ====  =====  ====
=      ====  ====  =====  ====
=  ===  ===        =====  ====
=  ====  ==  ====  =====  ====
=  ===  ===  ====  =====  ====
=      ====  ====  =====  ====
=============================="

echo "
Downloading the latest version of bat-wrapper

"

curl https://repository-master.mulesoft.org/nexus/content/repositories/releases/com/mulesoft/bat/bat-wrapper/1.1.14/bat-wrapper-1.1.14.zip --output $HOME/.batWrapper

# unzip bat wrapper
echo "
Unzip bat wrapper
"
(mkdir -p $HOME/.bat || true)
pushd $HOME/.bat
(rm -rf  $HOME/.bat/bat || true)
unzip $HOME/.batWrapper

if [ -w "/usr/local/bin" ]; then WRITEABLE=true; else WRITABLE=false; fi

# point `bat` to the actual paths
if [ "$WRITEABLE" == "true" ]; then
        echo "$HOME/.bat/bat/bin/bat \"\$@\"" > /usr/local/bin/bat  && chmod +x /usr/local/bin/bat
else
        echo "-------------------------------------------------------------------"
        echo "Please add $HOME/.bat/bat/bin to path in order to execute bat"
        echo "-------------------------------------------------------------------"
fi
rm $HOME/.batWrapper

$HOME/.bat/bat/bin/bat --help
