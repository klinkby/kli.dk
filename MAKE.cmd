@SET AZURE_STORAGE_ACCOUNT=klidkstatic
@SET AZURE_STORAGE_KEY=YN4E3Eh6YersWTLl1RHmbaD4qIyWn6mq1L6lrNMeVXnKhsIpgUyxvNxBO4UfjYeJKNj2yvO/3NfRYsKG4ZMwHA==
pushd src
..\hugo
..\hugo deploy --maxDeletes -1
popd