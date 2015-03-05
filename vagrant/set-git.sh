cd panoptes/current
git remote set-url origin git@github.com:cggh/panoptes.git
git checkout master
cd webapp/scripts/DQX
git remote set-url origin git@github.com:cggh/DQX.git
git checkout master
cd ../../../build/DQXServer
git remote set-url origin git@github.com:cggh/DQXServer.git
git checkout master
cp config.py ../../..
cd ..
ln -s panoptes-virtualenv virtualenv
