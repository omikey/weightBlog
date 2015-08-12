require 'pry'

class MainController < ActionController::Base
  protect_from_forgery with: :exception

  def index

  end

  def add
    if session[:show_menu]
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
      @post_url = @s3_direct_post.url.to_s.gsub!('s3.amazonaws.com','s3-us-west-2.amazonaws.com')

      @policy = Base64.encode64(
          {
              expiration: 24.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%SZ'),
              conditions: [
                  {bucket: 'assets-japanfour'},
                  {acl: 'public-read'},
                  ['starts-with', '$key', ''],
                  {success_action_status: '201'}
              ]
          }.to_json
      ).gsub(/\n|\r/, '')

      @siggy = Base64.encode64(
          OpenSSL::HMAC.digest(
              OpenSSL::Digest::Digest.new('sha1'),
              'Y6nL9iyGnWHQhYJUxrU0GjhYa/q0fyrvXdDnBIlz',
              @policy
          )
      ).gsub(/\n/, '')
    end
  end

  def submit
    if session[:show_menu]
      dates = params[:date].split('/')
      date = DateTime.parse([dates[1],dates[0],dates[2]].join('/'))
      content = params[:content]
      size = params[:size]
      days = 0 - (DateTime.parse('7/8/2015 12:00am').mjd - date.mjd)
      Weight.create(size: size, day: days)
      Post.create(date: date, content: content)
    end
  end

  def get_post
    date = params[:date].to_i
    post = Post.all.order(:id).fetch(date).as_json
    post['date'] = post['date'].strftime('%m/%d/%Y %I:%M%p').downcase
    render json: {p: post, t: Post.all.count}
  end

  def get_weights
    day = params[:day].to_i
    weights = Weight.where(day: 0..day)
    render json: {weights: weights}
  end

  def sign_in
    user = User.where(username: params[:user], password: params[:pass])
    if user.count == 1
      session[:show_menu] = true
      render json: {success: true}
    else
      session[:show_menu] = false
      render json: {success: false}
    end
  end

end
