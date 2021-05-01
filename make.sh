#! /bin/bash
sh ./init.sh
# init.sh sets storage env.
# export AZURE_STORAGE_ACCOUNT=???
# export AZURE_STORAGE_KEY=???
cd src
hugo
hugo deploy --maxDeletes -1 
popd 
