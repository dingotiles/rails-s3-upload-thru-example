class UploadsController < ApplicationController
  def new
  end

  def create
    # Make an object in your bucket for your upload
    p BUCKET
    p params[:file]
    p params[:file].original_filename

    file_data = params[:file]
    if file_data.respond_to?(:read)
      contents = file_data.read
    elsif file_data.respond_to?(:path)
      contents = File.read(file_data.path)
    else
      logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      flash.now[:notice] = 'Uploaded file was corrupted somewhere in transit'
      render :new
      return
    end

    s3_file = BUCKET.files.new(
      key: params[:file].original_filename,
      body: file_data,
      public: true
    )

    if s3_file.save
      p s3_file

      # Create model object for the upload
      @upload = Upload.new(
        url: s3_file.public_url,
        name: s3_file.key
      )

      # Save the upload
      if @upload.save
        redirect_to uploads_path, success: 'File successfully uploaded'
      else
        flash.now[:notice] = 'There was an error updating database'
        render :new
      end
    else
      flash.now[:notice] = 'There was an error uploading file to object store'
      render :new
    end
  end

  def index
    @uploads = Upload.all
  end
end
