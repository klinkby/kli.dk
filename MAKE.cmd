@SET AZURE_STORAGE_ACCOUNT=??
@SET AZURE_STORAGE_KEY=??
pushd src
..\hugo
..\hugo deploy --maxDeletes -1
popd
