echo test > test.txt
aws s3 cp test.txt s3://$SOURCE_BUCKET/test.txt

sleep 5

aws s3 ls s3://$DESTINATION_BUCKET