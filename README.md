install:
chmod 777 dir.sh (replace dir.sh with file path)
sudo mv /usr/bin/dir /usr/bin/old_dir (i think dir is a symlink to ls but idk)
sudo cp dir.sh /usr/bin/dir
