AWS_KEY="AKIAQMLDLASIZMTS3LWJ"
AWS_SECRET="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"
S3_BUCKET="cctv-task4"
S3_BUCKET_PATH="/ecamcunano-upload/"
S3_ACL="x-amz-acl:private"

function s3Upload
{
  path=$1
  file=$2

  acl=${S3_ACL}
  bucket=${S3_BUCKET}
  bucket_path=${S3_BUCKET_PATH}

  date=$(date +"%a, %d %b %Y %T %z")
  content_type="application/octet-stream"
  sig_string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$bucket_path$file"
  signature=$(echo -en "${sig_string}" | openssl sha1 -hmac "${AWS_SECRET}" -binary | base64)

  curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${AWS_KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$bucket_path$file"
}

# set the path based on the first argument
path='/home/yixin/S3upload_bash'

# loop through the path and upload the files
for file in "$path"/*; do
  s3Upload "$path" "${file##*/}" "/"
done
