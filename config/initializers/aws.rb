if ENV['VCAP_SERVICES']
  aws_s3_credentials = CF::App::Credentials.find_by_service_tag('s3')
  aws_s3_credentials ||= CF::App::Credentials.find_by_service_tag('blob')
  aws_s3_credentials ||= CF::App::Credentials.find_by_service_tag('object-store')

  unless aws_s3_credentials
    $stderr.puts "Application not bound to AWS S3 service instance"
    exit 1
  end
  access_key_id = aws_s3_credentials["access_key_id"]
  secret_access_key = aws_s3_credentials["secret_access_key"]
  bucket = aws_s3_credentials["bucket"]
else
  access_key_id = ENV['AWS_ACCESS_KEY']
  secret_access_key = ENV['AWS_SECRET_KEY']
  bucket = ENV['BUCKET']
  $stderr.puts "ERROR: missing $AWS_ACCESS_KEY" if access_key_id.blank?
  $stderr.puts "ERROR: missing $AWS_SECRET_KEY" if secret_access_key.blank?
  $stderr.puts "ERROR: missing $BUCKET" if bucket.blank?
end

Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(access_key_id, secret_access_key),
})
S3_BUCKET = Aws::S3::Resource.new.bucket(bucket)
