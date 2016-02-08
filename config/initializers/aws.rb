if ENV['VCAP_SERVICES']
  aws_s3_credentials = CF::App::Credentials.find_by_service_tag('s3')
  aws_s3_credentials ||= CF::App::Credentials.find_by_service_tag('blob')
  aws_s3_credentials ||= CF::App::Credentials.find_by_service_tag('object-store')

  unless aws_s3_credentials
    $stderr.puts "Application not bound to AWS S3 service instance"
    exit 1
  end
  aws_access_key_id = aws_s3_credentials["access_key_id"]
  aws_secret_access_key = aws_s3_credentials["secret_access_key"]
  bucket = aws_s3_credentials["bucket"]
end

unless aws_access_key_id && aws_secret_access_key
  aws_access_key_id ||= ENV['AWS_ACCESS_KEY_ID']
  aws_secret_access_key ||= ENV['AWS_SECRET_ACCESS_KEY']
  bucket = ENV['BUCKET']
  $stderr.puts "ERROR: missing $AWS_ACCESS_KEY_ID" if aws_access_key_id.blank?
  $stderr.puts "ERROR: missing $AWS_SECRET_ACCESS_KEY" if aws_secret_access_key.blank?
  $stderr.puts "ERROR: missing $BUCKET" if bucket.blank?
end

FOG_STORAGE = Fog::Storage.new(
  provider: 'aws',
  aws_access_key_id: aws_access_key_id,
  aws_secret_access_key: aws_secret_access_key
)
BUCKET = FOG_STORAGE.directories.get(bucket)
