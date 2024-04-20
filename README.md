install: /n
```
chmod 777 dir.sh (replace dir.sh with file path) /n
sudo mv /usr/bin/dir /usr/bin/old_dir (i think dir is a symlink to ls but idk) /n
sudo cp dir.sh /usr/bin/dir /n
```
optional! add
```
PROMPT_COMMAND='PS1="C:$(pwd)>"'
echo $(uname -o) [$(uname -sr)]
echo "Copyright (c) 2019 Maristocratic Communications. Few rights reserved."
echo
```
to bashrc for best experience
