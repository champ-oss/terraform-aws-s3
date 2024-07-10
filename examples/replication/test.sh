if [ "$ENABLED" = "true" ]; then
  echo test > test.txt
  aws s3 cp test.txt s3://$SOURCE_BUCKET/test.txt

  for i in {1..30}; do
    aws s3 ls s3://$DESTINATION_BUCKET | grep test.txt
    result=$?
    if [[ $result -eq 0 ]]
    then
      echo "found replicated file in destination"
      break
    else
      echo "replicated file not found in destination"
      sleep 5
    fi
    done

  if [[ $result -ne 0 ]]
  then
    exit 1
  fi
else
  echo "Module is disabled, no resources created"
fi