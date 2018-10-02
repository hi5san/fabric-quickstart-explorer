FROM hi5san/fabric-quickstart:v1.2.0-nomarbles

# add hyperledger-explorer
RUN echo '#!/bin/sh' > $HOME/installExplorer.sh && \
    echo 'git clone https://github.com/hyperledger/blockchain-explorer.git -b release-3.7' >> $HOME/installExplorer.sh && \
    echo 'sudo DEBIAN_FRONTEND=noninteractive apt install locate postgresql -y' >> $HOME/installExplorer.sh && \
    echo 'sudo systemctl enable postgresql' >> $HOME/installExplorer.sh && \
    echo "sudo sed -i.bak '/^host.*md5/ s/md5/trust/' /etc/postgresql/*/main/pg_hba.conf" >> $HOME/installExplorer.sh && \
    echo 'sudo service postgresql start' >> $HOME/installExplorer.sh && \
    echo 'sudo apt install jq -y' >> $HOME/installExplorer.sh && \
    echo 'cd $HOME/blockchain-explorer/app/persistence/fabric/postgreSQL/db'  >> $HOME/installExplorer.sh && \
    echo './createdb.sh' >> $HOME/installExplorer.sh && \
    echo 'cd $HOME/blockchain-explorer' >> $HOME/installExplorer.sh && \
    echo "sed -i.bak 's@fabric-path@'$HOME'@' app/platform/fabric/config.json" >> $HOME/installExplorer.sh && \
    echo 'npm install; cd client; npm install; npm run build'  >> $HOME/installExplorer.sh && \
    chmod a+rx $HOME/installExplorer.sh && \
    ./installExplorer.sh

RUN echo '#!/bin/sh' > $HOME/runExplorer.sh && \
    echo 'if [ ! -d $HOME/fabric-samples/bin ]; then $HOME/installFabric.sh; fi' >> $HOME/runExplorer.sh && \
    echo 'echo Running byfn..' >> $HOME/runExplorer.sh && \
    echo '(cd fabric-samples/first-network; echo Y | ./byfn.sh down; echo Y | ./byfn.sh up)' >> $HOME/runExplorer.sh && \
    echo 'echo Starting explorer in 5 seconds...' >> $HOME/runExplorer.sh && \
    echo 'sleep 5' >> $HOME/runExplorer.sh && \
    echo 'cd blockchain-explorer; ./start.sh;' >> $HOME/runExplorer.sh && \
    echo 'echo Explorer started.  Begin tailing console log in 5 seconds...' >> $HOME/runExplorer.sh && \
    echo 'sleep 5' >> $HOME/runExplorer.sh && \
    echo 'tail -f -n +1 logs/console/*.log' >> $HOME/runExplorer.sh && \
    chmod a+rx $HOME/runExplorer.sh

RUN echo '#!/bin/sh' > $HOME/playWithCLI.sh && \
    echo 'echo == Running peer version...' >> $HOME/playWithCLI.sh && \
    echo 'docker exec cli peer version' >> $HOME/playWithCLI.sh && \
    echo 'sleep 3' >> $HOME/playWithCLI.sh && \
    echo 'echo == Running peer node status...' >> $HOME/playWithCLI.sh && \
    echo 'docker exec cli peer node status' >> $HOME/playWithCLI.sh && \
    echo 'sleep 3' >> $HOME/playWithCLI.sh && \
    echo 'echo == Running peer query for a and b..' >> $HOME/playWithCLI.sh && \
    echo docker exec cli peer chaincode query -C mychannel -n mycc -c \''{"Args":["query","a"]}'\' >> $HOME/playWithCLI.sh && \
    echo docker exec cli peer chaincode query -C mychannel -n mycc -c \''{"Args":["query","b"]}'\' >> $HOME/playWithCLI.sh && \
    echo 'sleep 3' >> $HOME/playWithCLI.sh && \
    echo 'echo == Running peer invoke transfer a b 25..' >> $HOME/playWithCLI.sh && \
    echo docker exec cli peer chaincode invoke -o orderer.example.com:7050  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem  -C mychannel -n mycc -c \''{"Args":["invoke","a","b","25"]}'\' >> $HOME/playWithCLI.sh && \
    echo 'sleep 3' >> $HOME/playWithCLI.sh && \
    echo 'echo == Running peer query again for a and b..' >> $HOME/playWithCLI.sh && \
    echo docker exec cli peer chaincode query -C mychannel -n mycc -c \''{"Args":["query","a"]}'\' >> $HOME/playWithCLI.sh && \
    echo docker exec cli peer chaincode query -C mychannel -n mycc -c \''{"Args":["query","b"]}'\' >> $HOME/playWithCLI.sh && \
    chmod a+rx $HOME/playWithCLI.sh
 
CMD sudo service docker start && sudo service postgresql start && /bin/bash
