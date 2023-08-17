echo test > test.txt
aws s3 cp test.txt s3://$SOURCE_BUCKET/test.txt

for i in {1..10}; do
  aws s3 ls s3://$DESTINATION_BUCKET | grep test.txt
  result=$?
  if [[ $result -eq 0 ]]
  then
    echo "found replicated file"
    break
  else
    echo "replicated file not found"
    sleep 3
  fi
done

if [[ $result -ne 0 ]]
then
  echo "the file was not replicated"
  exit 1
fi