FROM hi5san/fabric-quickstart:v1.1.0

#add hyperledger-explorer
RUN echo '#!/bin/sh' > $HOME/installExplorer.sh && \
    echo 'git clone https://github.com/hyperledger/blockchain-explorer.git' >> $HOME/installExplorer.sh && \
    echo 'sudo apt install locate postgresql -y' >> $HOME/installExplorer.sh && \
    echo 'sudo systemctl enable postgresql' >> $HOME/installExplorer.sh && \
    echo 'sudo service postgresql start' >> $HOME/installExplorer.sh && \
    echo 'cd $HOME/blockchain-explorer'  >> $HOME/installExplorer.sh && \
    echo 'sudo -u postgres psql -f app/persistance/postgreSQL/db/explorerpg.sql' >> $HOME/installExplorer.sh && \
    echo 'sudo -u postgres psql -f app/persistance/postgreSQL/db/updatepg.sql' >> $HOME/installExplorer.sh && \
    echo "sed -i -e 's@fabric-path@'$HOME'@' app/platform/fabric/config.json" >> $HOME/installExplorer.sh && \
    echo 'npm install; cd client; npm install; npm run build'  >> $HOME/installExplorer.sh && \
    chmod a+rx $HOME/installExplorer.sh && \
    ./installExplorer.sh

RUN echo '#!/bin/sh' > $HOME/runExplorer.sh && \
    echo 'if [ ! -d $HOME/bin ]; then $HOME/installFabric.sh; fi' >> $HOME/runExplorer.sh && \
    echo 'echo Running byfn..' >> $HOME/runExplorer.sh && \
    echo '(cd fabric-samples/first-network; echo Y | ./byfn.sh down; echo Y | ./byfn.sh up)' >> $HOME/runExplorer.sh && \
    echo 'echo Starting explorer in 5 seconds...' >> $HOME/runExplorer.sh && \
    echo 'sleep 5' >> $HOME/runExplorer.sh && \
    echo 'cd blockchain-explorer; ./start.sh;' >> $HOME/runExplorer.sh && \
    echo 'echo Explorer started.  Begin tailing console log in 5 seconds...' >> $HOME/runExplorer.sh && \
    echo 'sleep 5' >> $HOME/runExplorer.sh && \
    echo 'tail -f -n +1 logs/console/console.log*' >> $HOME/runExplorer.sh && \
    chmod a+rx $HOME/runExplorer.sh

CMD sudo service docker start && sudo service postgresql start && /bin/bash
